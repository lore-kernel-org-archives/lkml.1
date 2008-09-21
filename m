Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbYIUS5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbYIUS5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 14:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYIUS5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 14:57:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56642 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbYIUS5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 14:57:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Regression] Commit 2344abbcbdb82140050e8be29d3d55e4f6fe860b breaks resume on nx6325
Date: Sun, 21 Sep 2008 21:03:16 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Kernel Testers <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
References: <200809210124.30547.rjw@sisk.pl> <200809210132.46504.rjw@sisk.pl>
In-Reply-To: <200809210132.46504.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809212103.17578.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 21 of September 2008, Rafael J. Wysocki wrote:
> On Sunday, 21 of September 2008, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > Unfortunately resume from suspend to RAM is completely broken on my hp nx6325
> > because of
> > 
> > commit 2344abbcbdb82140050e8be29d3d55e4f6fe860b
> > Author: Thomas Gleixner <tglx@linutronix.de>
> > Date:   Tue Sep 16 11:32:50 2008 -0700
> > 
> >     clockevents: make device shutdown robust
> > 
> >     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Reverting of this commit makes things work again.
> 
> One more thing, "broken" means that the box doesn't resume (the suspend part
> seems to work correctly) and instead it seems to enter a neverending loop
> that cannot be broken by any means except for the power button, so I think it
> occurs with interrupts disabled.

Update:

After some more debugging I verified that in fact the $subject commit breaks
CPU hotplugging (the 'online' part), so I should be able to get some more
information about what really happens.

This still will be difficult, because the box hangs solid (magic sysrq doesn't
work in this state) almost immediately after a (failing) attempt to 'online' the
previously 'offlined' CPU.

Thanks,
Rafael
