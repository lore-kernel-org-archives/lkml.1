Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbZHQLD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbZHQLD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757664AbZHQLD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:03:57 -0400
Received: from www.tglx.de ([62.245.132.106]:54008 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbZHQLD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:03:56 -0400
Date: Mon, 17 Aug 2009 13:03:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Buesch <mb@bu3sch.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Threaded interrupt handlers broken?
In-Reply-To: <alpine.LFD.2.00.0908171255570.2782@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0908171302430.2782@localhost.localdomain>
References: <200908161153.14081.mb@bu3sch.de> <200908162301.21775.mb@bu3sch.de> <alpine.LFD.2.00.0908162316150.2782@localhost.localdomain> <200908171223.57412.mb@bu3sch.de> <alpine.LFD.2.00.0908171255570.2782@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009, Thomas Gleixner wrote:

> On Mon, 17 Aug 2009, Michael Buesch wrote:
> > Ok, I added some more debugging code:
> > http://bu3sch.de/patches/wireless-testing/20090817-1219/patches/001-hack-threaded-irqs.patch
> > 
> > Here's the result:
> > http://bu3sch.de/misc/dmesg2
> >
> > Is it possible that the irq_to_desc() in irq_thread() fails and the
> > resulting desc pointer points to something random? That could
> > probably explain why the bit is set and why the spinlock is
> > uninitialized. But it would not explain why desc->lock would still
> > work... Maybe irq_to_desc() returns a descriptor to another irq (!=
> > 52)?
> 
> That would cause the whole irq code to fail. Can you send/upload your
> .config please ?

Also just add printk("desc: %p \n", desc); to the various places to
make sure that your pointers are correct.

Thanks,

	tglx
