Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbXGGMTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbXGGMTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 08:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbXGGMTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 08:19:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59496 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753037AbXGGMTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 08:19:37 -0400
Date: Sat, 7 Jul 2007 14:19:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oliver@neukum.org, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070707121913.GD3111@elf.ucw.cz>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705220444.GD3881@elf.ucw.cz> <E1I6huk-0003AH-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I6huk-0003AH-00@dorka.pomaz.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-07-06 09:07:38, Miklos Szeredi wrote:
> > > Actually fuse allows SIGKILL, because it's always fatal, and the
> > > syscall may not be restarted.
> > 
> > Okay, and you should handle refrigerator in the same paths where you
> > handle SIGKILL. Just add try_to_freeze() there...
> 
> It's the fourth time I'm repeating this in this thread:
> 
> Yes adding try_to_freeze() there would partially solve the probelem.
> 
> But another task can be sleeping on a mutex held by the task waiting
> for the reply.  And the freezer won't be able to handle that one.
> 
> Generally, calling try_to_freeze() with mutexes held is not a good
> idea.

Agreed, calling try_to_freeze() with mutex held is no-no, and it is
even documented somewhere.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
