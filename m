Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbXFMIXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbXFMIXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbXFMIXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:23:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47696 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754088AbXFMIXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:23:11 -0400
Date: Wed, 13 Jun 2007 10:22:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070613082258.GG13747@elf.ucw.cz>
References: <200706071530.51552.jesse.barnes@intel.com> <20070612145007.GA5986@ucw.cz> <200706120829.21465.jesse.barnes@intel.com> <20070612213020.GA13747@elf.ucw.cz> <2c0942db0706121438y6d2d2bb5qbe11269691366d20@mail.gmail.com> <20070612215501.GE13747@elf.ucw.cz> <2c0942db0706121725o9621b3bv35fc8ccf563b6fbb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0706121725o9621b3bv35fc8ccf563b6fbb@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Panicking when it's not necessary is anti-social. If the kernel can
> >> continue, then it should, unless it's a correctness issue that may
> >> cause data corruption. Given that the kernel can even work around the
> >> problem now, throwing a panic is even less warranted.
> >
> >Printk("*********************** WARNING")
> >
> >is anti-social, too.
> 
> Pavel, this warning isn't even going to print on any of your systems.
> So it's completely different than the straw-man you're proposing (that
> I snipped).
> 
> Look, if you want to argue that the stars should go away, then sure,
> I'm not going to stop you. But panicking over a BIOS misconfiguration
> issue? One that can be corrected by the kernel? That's just plain
> stupid.

Well, either the warning is _really_ important. Then it is not really
warning, but a fatal problem, and we should panic for it (so that user
sees the message) and ask for a command line option (so we really
really know user wants to ignore that warning).

Or it is important but not _that_ important. We have
printk(KERN_EMERG) for that.

Or maybe it is not so important. We have printk(KERN_WARNING) for
that.

Pick one, but doing "KERN_WARNING" level with message
"************************* I'm extremely important warning,
************************** uhuh maybe there is something bad in your
bios but I'm not really sure" is just wrong.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
