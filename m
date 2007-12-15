Return-Path: <linux-kernel-owner+w=401wt.eu-S1761718AbXLOW7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761718AbXLOW7x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 17:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758912AbXLOW7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 17:59:38 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37782 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757361AbXLOW7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 17:59:37 -0500
Date: Sat, 15 Dec 2007 23:59:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rene Herman <rene.herman@gmail.com>, "David P. Reed" <dpreed@reed.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071215225943.GE2434@elf.ucw.cz>
References: <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <476250D5.8000409@gmail.com> <20071214142355.GA10130@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214142355.GA10130@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-12-14 15:23:55, Ingo Molnar wrote:
> 
> * Rene Herman <rene.herman@gmail.com> wrote:
> 
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -229,10 +229,9 @@ static int __init obsolete_checksetup(char *line)
> >  }
> >
> >  /*
> > - * This should be approx 2 Bo*oMips to start (note initial shift), and will
> > - * still work even if initially too large, it will just take slightly longer
> > + * Initial value roughly corresponds to a 1 GHz CPU
> >   */
> > -unsigned long loops_per_jiffy = (1<<12);
> > +unsigned long loops_per_jiffy = 1000000000 / HZ;
> >
> >  EXPORT_SYMBOL(loops_per_jiffy);
> 
> this is a factor of ~2400 increase - this will take an eternity to boot 
> on any older CPU.

I don't think we are using outb_p before loops_per_jiffy are
initialized -- I believe I'd see oopsen if we did. Factor 2400
increase is bad, but if it only converts 10x 1usec delay into 10x
24msec delay, it is not _that_ bad.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
