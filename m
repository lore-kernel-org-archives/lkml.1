Return-Path: <linux-kernel-owner+w=401wt.eu-S1765683AbXFEURR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765683AbXFEURR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 16:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764032AbXFEURH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:17:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37759 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761044AbXFEURG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:17:06 -0400
Date: Tue, 5 Jun 2007 22:16:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Linux 2.6.22-rc4
Message-ID: <20070605201643.GA4424@elf.ucw.cz>
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org> <4665B169.2030803@googlemail.com> <alpine.LFD.0.98.0706051219560.4921@woody.linux-foundation.org> <20070605193718.GB24877@elte.hu> <alpine.LFD.0.98.0706051245190.4921@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706051245190.4921@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > isnt the refrigerator() suspend related? Perhaps suspend disables irqs 
> > somewhere that we forgot to track?
> 
> There _is_ something strange there. For that whole sequence to trigger, 
> the current task has to have the TIF_FREEZE bit set, but I don't see why 
> it would be during shutdown.

[  116.733327] PM: suspend-to-disk mode set to 'shutdown'
[  116.738849] swsusp: Basic memory bitmaps created
[  116.745353] Stopping tasks ... WARNING: at
/home/devel/linux-git/kernel/lockdep.c:2414 check_flags()
[  116.754921]  [<c0404fbf>] show_trace_log_lvl+0x1a/0x2f
[  116.754937]  [<c0405bd6>] show_trace+0x12/0x14

No, he's not shutting down, he's trying to snapshot his
machine. 'shutdown' will be done at end of hibernation, _way_ after
this.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
