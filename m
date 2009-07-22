Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbZGVQjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbZGVQjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZGVQjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:39:35 -0400
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:26872 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753530AbZGVQje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:39:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=T3G8m7X7tKWUwaud1RmQL0SqNIJ9ggiPjUezq2j65+l7TxexuGPikZif3ma4pjCjpyhJYXaUG8HvzKewPm3d8n+f6gDuFUqMDoZI7HWCMX68KeYe7Ojfx7z0yMgPqCLDWwmIt3Fspfm4h5ZyJibN8Xj0y385OssRKeWBtW1DBIQ=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: PqtSCusVM1kEAhy6inUMm_kH432MXmQMwBJEfyXjcSYGEukhRHKPZXEBaHwFZRLO7MNLNDJ3XD2.qzfsof05RopohKJpO4CMUQVG_MnLakde3jdYA2NRhUzViAwRomfQ7FyuqIrAStbHK25jhrTEBcTKCf0RKHNiIxv.hy.uwTt6JjnL5IsaX01NnHL1uVIk8LA7pB3bxNKToCzkO285binnMaPBPlsZp9kgjR9BiASDqhdq3II5XosxyxV.AAOjganpvFGLwQeJVWxHu8.YYhTSJszaBqIt2IALQooJYSX21.2S
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Date: Wed, 22 Jul 2009 09:39:32 -0700
User-Agent: KMail/1.9.10
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Peter Zijlstra <peterz@infradead.org>
References: <20090714100634.GA4054@elf.ucw.cz> <20090721160436.GD4352@dtor-d630.eng.vmware.com> <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907220939.33399.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Thomas Gleixner wrote:
>       See http://lkml.org/lkml/2009/7/17/174 

Interesting.  The model is then to switch over to __set_irq_handler(),
or maybe set_irq_chip_and_handler(), to replace the toplevel dispatch
code for will-be-threaded IRQs which happen to be hooked up to inputs
that don't sense edges.  (Agree, that seems like a goof.  But hardware
designers sometimes have any choices there.)

The normal model is that boards don't get involved with that level of
logic ... all IRQs get set up once on generic code, and flow handlers
don't change.  Or if they do change, it's done when changing the IRQ's
trigger mode from edge to level, or vice versa.

Can that be cleaned up a bit, so that the handle_level_oneshot_irq()
and unmask_oneshot_irq() stuff kicks in automatically when needed,
instead of requiring board-specific (or driver-specific) code to get
that stuff right?

- Dave

