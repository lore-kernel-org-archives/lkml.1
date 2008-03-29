Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYC2VjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYC2VjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 17:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYC2VjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 17:39:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40875 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbYC2VjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 17:39:05 -0400
Date: Sat, 29 Mar 2008 22:39:43 +0100
From: Pavel Machek <pavel@suse.cz>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: perex@perex.cz, kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>, tiwai@suse.de
Subject: Re: sound/core.h: evil #ifdefs
Message-ID: <20080329213943.GA15507@elf.ucw.cz>
References: <20080329205700.GA11295@elf.ucw.cz> <1206824425.6543.28.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206824425.6543.28.camel@brick>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > snd_minor_info_oss_* is an function returning int _or_ comment,
> > depending on config parameters. That is truly evil, fix it.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > 
> > diff --git a/include/sound/core.h b/include/sound/core.h
> > index 4fc0235..452000d 100644
> > --- a/include/sound/core.h
> > +++ b/include/sound/core.h
> > @@ -277,8 +277,8 @@ #ifdef CONFIG_SND_OSSEMUL
> >  int snd_minor_info_oss_init(void);
> >  int snd_minor_info_oss_done(void);
> >  #else
> > -#define snd_minor_info_oss_init() /*NOP*/
> > -#define snd_minor_info_oss_done() /*NOP*/
> > +static inline snd_minor_info_oss_init(void) { return 0; }
>    static inline int snd_minor_info_oss_init(void) { return 0; }
> 
> > +static inline snd_minor_info_oss_done(void) { return 0; }
>    static inline int snd_minor_info_oss_done(void) { return 0; }
> >  #endif

yep, thanks, scratch that patch.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
