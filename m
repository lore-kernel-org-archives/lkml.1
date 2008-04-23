Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYDWNtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYDWNtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYDWNtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:49:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1176 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753054AbYDWNtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:49:01 -0400
Date: Wed, 23 Apr 2008 10:53:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Adrian Bunk <bunk@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080423085356.GB8723@ucw.cz>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <480C8FD6.3030700@zytor.com> <20080421195517.GH8770@elte.hu> <480CF2F9.4060608@zytor.com> <20080421201129.GL8770@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421201129.GL8770@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-04-21 22:11:29, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Ingo Molnar wrote:
> >>
> >> sure - but no need to be rude and mark it BROKEN when we've got this much 
> >> better tool named "email". BROKEN is really just for cases where there's 
> >> no-one willing to fix things.
> >
> > I'm not trying to be rude, I'm just trying to avoid putting an 
> > unnecessary burden on testers and just let Kconfig know not to pick 
> > this particular random path.  Obviously, Kconfig doesn't care, but 
> > it's clear BROKEN has negative associations; besides, it really is 
> > unnecessarily strong.
> >
> > Perhaps what we need is NORAND?
> 
> yep, i was thinking about CONFIG_BROKEN2 already :-)
> 
> then i came up with: CONFIG_NON_GENERIC. All code that can break a 
> normal bootup should be marked with that. Such as CONFIG_ROOT_NFS=y 
> [panics on bootup] or CONFIG_EUROTECH_WDT=y [crashes on bootup] or 
> CONFIG_SND_MTPAV [hangs on bootup] and the dozens of other config 
> options i had to map when trying to bring up an allyesconfig kernel for 
> the first time ;-)

You certainly have my vote here. There's really big difference between
'this breaks boot when y (NFS_ROOT)' and 'this is mostly harmless when
y (any sane driver)'.

Actually in nfsroot case, we should probably fix the code so that it
is a nop w/out commandline option.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
