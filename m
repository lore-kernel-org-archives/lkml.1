Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYFDHGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYFDHGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 03:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYFDHGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 03:06:04 -0400
Received: from www.tglx.de ([62.245.132.106]:43059 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbYFDHGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 03:06:02 -0400
Date: Wed, 4 Jun 2008 09:05:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: =?ISO-8859-15?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable
 interrupts
In-Reply-To: <20080604063005.GA22952@digi.com>
Message-ID: <alpine.LFD.1.10.0806040901400.3235@apollo.tec.linutronix.de>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local> <20080523055527.GA28963@digi.com> <20080523104454.4e2af6ec@bluebox.local> <20080523091009.GA22821@digi.com> <20080523120308.7bec1e1c@bluebox.local> <20080523105604.GA23800@digi.com>
 <20080523135557.27fe4855@bluebox.local> <20080523113650.2467f2ee.randy.dunlap@oracle.com> <20080524004917.6a226e96@dilbert.local> <20080604063005.GA22952@digi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-80296366-1212563145=:3235"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-80296366-1212563145=:3235
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 4 Jun 2008, Uwe Kleine-König wrote:
> Hello Hans-Jürgen,
> 
> > Sometimes it is necessary to enable/disable the interrupt of a UIO device
> > from the userspace part of the driver. With this patch, the UIO kernel driver
> > can implement an "irqcontrol()" function that does this. Userspace can write
> > an s32 value to /dev/uioX (usually 0 or 1 to turn the irq off or on). The
> > UIO core will then call the driver's irqcontrol function.
> IMHO it would make sense to demand that irqcontrol() is idempotent and
> then call irqcontrol(ON) before blocking in read and poll.

We thought about that, but it is racy. Also explicit control is way
better than automagic hackery.

Thanks,
	tglx



--8323328-80296366-1212563145=:3235--
