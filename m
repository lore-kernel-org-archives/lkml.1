Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZGVQ5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZGVQ5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZGVQ5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:57:18 -0400
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:22859 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752054AbZGVQ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:57:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=moypcimLfQeUkVFaBbhG4qLFYrWrrzpD+Gmkb2PEnIVgqVqEjkkHDZmg78tg9ylbxq4EwQ/1p1HEw5bWuaZT/kSIt/zyByURDF6G5BN0oYTZCWwqaSltJQiIUYvxwId2UNuL9kF7NERJRJuJ9Rf6/5g9DLxYLnfccPuS9HDhsbI=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: f7.wKocVM1lfC.jOXdkemKZldKdscTJnhVwvUt48_1IzSND6q8mZG5zi3S4CCTLPAj3c_42qMUsQV9KFMK_faZgbBJHTGqX92iAzOJ020sfGBM0BovyvIRFdCK9i7fHcZlJ8Z_BaDgQGwLcEdh6O_uBZVyYmLhcvdo3cBPM6vZoZS1xRV1BIi4cyn9PrlTRuSCL3val8Z2Fv7bhDCerXlIfN6YKH4FtgwlDNSGuiKFrQx.ZwVXhklMDezDIRxv_FqWRwM1UvLEH3bwMh
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Date: Wed, 22 Jul 2009 09:57:15 -0700
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Daniel Ribeiro <drwyrm@gmail.com>
References: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain> <1248269443.27058.1449.camel@twins>
In-Reply-To: <1248269443.27058.1449.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907220957.16499.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Peter Zijlstra wrote:
> Wouldn't it be better if we could express the nesting property from
> within genirq, so that we can do things like:
> 
>   register_chip_nested(parent_chip, parent_irq, slave_chip);
> 
> And let genirq set-up the needed magic to make the nesting work.

I've been requesting such IRQ chaining support for some time
now ... if the ears are now listening, that kind of direction
should be pursued.


> Also, how important is it that subhandler1..n run in their own thread?

Completely unimportant in a practical sense.  Undesirable, even;
wasteful to allocate all those stack pages and keep them idle
most of the time.

There might be an argument that the design isn't technicaly done
until that model *can* be supported.  On the flip side, last time
this came up there was no "customer demand" for that ... it was
all "supplier push".


> That is, can't we let them run from the thread that is otherwise waiting
> for the completino anyway?

That would be far preferable, yes.

- Dave

