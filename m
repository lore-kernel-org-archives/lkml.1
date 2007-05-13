Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbXEMBDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbXEMBDE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 21:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbXEMBCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 21:02:46 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756907AbXEMBCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 21:02:45 -0400
Date: Sat, 12 May 2007 18:02:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lee Garrett <lee-in-berlin@web.de>
Cc: Truxton Fulton <trux@truxton.com>, linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
Subject: Re: [Bugme-new] [Bug 8378] New: Averatec 3156X laptop doesn't 
 reboot with kernels > 2.6.13.5 (responsible commit found)
Message-Id: <20070512180240.7a8923d5.akpm@linux-foundation.org>
In-Reply-To: <4646171E.7090609@web.de>
References: <200704271742.l3RHgPTH019561@fire-2.osdl.org>
	<20070427144434.970de79f.akpm@linux-foundation.org>
	<m2k5vx6vce.fsf@truxton.com>
	<4646171E.7090609@web.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 21:35:58 +0200 Lee Garrett <lee-in-berlin@web.de> wrote:

> Truxton Fulton wrote:
> > Hi,
> > 
> > I verified on my IDEQ210M that performing the old reboot sequence
> > followed by the new reboot sequence works for me, and I suspect that
> > it will work for Lee also.  Like this :
> > 
> > 	/* old method, works on most machines */
> >         for (i = 0; i < 100; i++) {
> >                 kb_wait();
> >                 udelay(50);
> >                 outb(0xfe, 0x64);         /* pulse reset low */
> >                 udelay(50);
> >         }
> > 
> > 	/* new method, sets the "System flag" which when set,
> > 	   indicates successful completion of the keyboard controller
> > 	   self-test (Basic Assurance Test, BAT).  This is needed
> > 	   for some machines with no keyboard plugged in */
> >         for (i = 0; i < 100; i++) {
> >                 kb_wait();
> >                 udelay(50);
> >                 outb(0x60, 0x64);         /* write Controller Command Byte */
> >                 udelay(50);
> >                 kb_wait();
> >                 udelay(50);
> >                 outb(0x14, 0x60);         /* set "System flag" */
> >                 udelay(50);
> >                 kb_wait();
> >                 udelay(50);
> >                 outb(0xfe, 0x64);         /* pulse reset low */
> >                 udelay(50);
> >         }
> > 
> > Thanks,
> > 
> > -Truxton
> 
> Hello everyone,
> 
> I compiled a 2.6.21.1 kernel with Truxton's suggestion mentioned 
> above. My laptop reboots normally with it. For convenience I've 
> diffed a patch, which is appended to this mail.
> 

OK, thanks.

So that are we doing here?  We try the pre-Truxton code and if that didn't
work we try the post-Truxton code?  Hard to see how that could go wrong.

Truxton, can you please test it for us?
