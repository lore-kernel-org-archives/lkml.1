Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbXCRAmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbXCRAmi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 20:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbXCRAmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 20:42:38 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33874 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752716AbXCRAmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 20:42:37 -0400
Date: Sun, 18 Mar 2007 01:42:40 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: tglx@linutronix.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>, Sergey Vlasov <vsu@altlinux.ru>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@atrey.karlin.mff.cuni.cz
Subject: appletouch quirk doesn't run at resume
Message-ID: <20070318004240.GO752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703162134.14265.rjw@sisk.pl> <1174078066.13341.279.camel@localhost.localdomain> <1174087552.13341.332.camel@localhost.localdomain> <45FBBDEA.9060708@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45FBBDEA.9060708@m3y3r.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 11:07:38AM +0100, Thomas Meyer wrote:
> Thomas Gleixner schrieb:
> > I finally found a dual core box, which survives suspend/resume without
> > crashing in the middle of nowhere. Sigh, I never figured out from the
> > code and the bug reports what's going on.
> >
> > The observed hangs are caused by a stale state transition of the clock
> > event devices, which keeps the RCU synchronization away from completion,
> > when the non boot CPU is brought back up.
> >
> > The suspend/resume in oneshot mode needs the similar care as the
> > periodic mode during suspend to RAM. My assumption that the state
> > transitions during the different shutdown/bringups of s2disk would go
> > through the periodic boot phase and then switch over to highres resp.
> > nohz mode were simply wrong.
> >
> > Add the appropriate suspend / resume handling for the non periodic
> > modes.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> >   
> 
> Excellent work. Now suspend to disk is working again. But:
> 
> 1.) The quirk added in commit a417a21e10831bca695b4ba9c74f4ddf5a95ac06
> for the appletouch driver doesn't seem to work after resume.
>...

Not a regression, but still a bug.
Appropriate people added to the Cc.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

