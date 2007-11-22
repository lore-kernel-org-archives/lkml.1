Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbXKVVVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbXKVVVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 16:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXKVVUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 16:20:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55118 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbXKVVUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 16:20:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tvrtko.ursulin@sophos.com
Subject: Re: [2.6.24-rc] pdflush stuck in D state
Date: Thu, 22 Nov 2007 22:39:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <OFACAE304F.F778F5BA-ON8025739B.005B6D78-8025739B.005B9AA8@sophos.com>
In-Reply-To: <OFACAE304F.F778F5BA-ON8025739B.005B6D78-8025739B.005B9AA8@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711222239.00866.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 of November 2007, tvrtko.ursulin@sophos.com wrote:
> linux-kernel-owner@vger.kernel.org wrote on 22/11/2007 16:28:22:
> 
> > linux-kernel-owner@vger.kernel.org wrote on 22/11/2007 16:34:01:
> > 
> > > On Thursday, 22 of November 2007, Tvrtko A. Ursulin wrote:
> > > > 
> > > > Hi all,
> > > > 
> > > > So as the subject says - pdflush is stuck i D state which means 
> > > constant load 
> > > > average of at least one:
> > > > 
> > > > root       151  0.0  0.0      0     0 ?        D    Nov20   0:33 
> > [pdflush]
> > > 
> > > Hm, this is supposed to be fixed.  Please see:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9323
> > 
> > Doesn't look like the same bug to me - I have only ever seen pdflush get 
> 
> > stuck in D, not random processes.
> > 
> > Also, I can confirm that -rc3 I am running contains the patch referenced 
> 
> > in your bugzilla link above.
> 
> Here is a trace for good and bad pdflush processes:
> 
> Nov 22 16:35:09 oxygene kernel:  =======================
> Nov 22 16:35:09 oxygene kernel: pdflush       S c014fe4e     0   150 2
> Nov 22 16:35:09 oxygene kernel:        00000000 00000046 00000000 c014fe4e 
> f7c30fa4 c014f9c6 f7ce8560 f7ce869c
> Nov 22 16:35:09 oxygene kernel:        c201e100 00000001 fffffffc 00000002 
> 00000000 00000000 00000000 00000000
> Nov 22 16:35:09 oxygene kernel:        00000021 f7c30fc8 c014fe4e 00000000 
> 00000000 c014ff09 00000202 f7ce8560
> Nov 22 16:35:09 oxygene kernel: Call Trace:
> Nov 22 16:35:09 oxygene kernel:  [pdflush+0/434] pdflush+0x0/0x1b2
> Nov 22 16:35:09 oxygene kernel:  [background_writeout+125/173] 
> background_writeout+0x7d/0xad
> Nov 22 16:35:09 oxygene kernel:  [pdflush+0/434] pdflush+0x0/0x1b2
> Nov 22 16:35:09 oxygene kernel:  [pdflush+187/434] pdflush+0xbb/0x1b2
> Nov 22 16:35:09 oxygene kernel:  [kthread+56/96] kthread+0x38/0x60
> Nov 22 16:35:09 oxygene kernel:  [kthread+0/96] kthread+0x0/0x60
> Nov 22 16:35:09 oxygene kernel:  [kernel_thread_helper+7/16] 
> kernel_thread_helper+0x7/0x10
> Nov 22 16:35:09 oxygene kernel:  =======================
> Nov 22 16:35:09 oxygene kernel: pdflush       D f7c3aef4     0   151 2
> Nov 22 16:35:09 oxygene kernel:        0b83b953 00000046 00000002 f7c3aef4 
> f7c3aeec 00000000 f7ce8ac0 f7ce8bfc
> Nov 22 16:35:09 oxygene kernel:        c201e100 00000001 f7c3af18 0b83b9cc 
> f7c3af18 00000003 00000000 00000001
> Nov 22 16:35:09 oxygene kernel:        00000000 f7c3af18 0b83b9cc f7c3af70 
> 00000000 c027ddb7 f781e000 c010490c
> Nov 22 16:35:09 oxygene kernel: Call Trace:
> Nov 22 16:35:09 oxygene kernel:  [schedule_timeout+112/141] 
> schedule_timeout+0x70/0x8d
> Nov 22 16:35:09 oxygene kernel:  [apic_timer_interrupt+40/48] 
> apic_timer_interrupt+0x28/0x30
> Nov 22 16:35:09 oxygene kernel:  [process_timeout+0/5] 
> process_timeout+0x0/0x5
> Nov 22 16:35:09 oxygene kernel:  [schedule_timeout+107/141] 
> schedule_timeout+0x6b/0x8d
> Nov 22 16:35:09 oxygene kernel:  [io_schedule_timeout+27/36] 
> io_schedule_timeout+0x1b/0x24
> Nov 22 16:35:09 oxygene kernel:  [congestion_wait+80/100] 
> congestion_wait+0x50/0x64
> Nov 22 16:35:09 oxygene kernel:  [autoremove_wake_function+0/53] 
> autoremove_wake_function+0x0/0x35
> Nov 22 16:35:09 oxygene kernel:  [pdflush+0/434] pdflush+0x0/0x1b2
> Nov 22 16:35:09 oxygene kernel:  [wb_kupdate+152/219] wb_kupdate+0x98/0xdb
> Nov 22 16:35:09 oxygene kernel:  [pdflush+282/434] pdflush+0x11a/0x1b2
> Nov 22 16:35:09 oxygene kernel:  [wb_kupdate+0/219] wb_kupdate+0x0/0xdb
> Nov 22 16:35:09 oxygene kernel:  [kthread+56/96] kthread+0x38/0x60
> Nov 22 16:35:09 oxygene kernel:  [kthread+0/96] kthread+0x0/0x60
> Nov 22 16:35:09 oxygene kernel:  [kernel_thread_helper+7/16] 
> kernel_thread_helper+0x7/0x10
> Nov 22 16:35:09 oxygene kernel:  =======================

Can you attach these traces to the Bugzilla entry at:
http://bugzilla.kernel.org/show_bug.cgi?id=9441 , please?

Thanks,
Rafael
