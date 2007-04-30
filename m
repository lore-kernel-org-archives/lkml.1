Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbXD3KrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbXD3KrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbXD3KrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:47:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:58538 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752100AbXD3KrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:47:17 -0400
Cc: linux-dvb@linuxtv.org, mkruky@linuxtv.org, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 30 Apr 2007 12:47:15 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <Pine.LNX.4.58.0704291753370.315@shell2.speakeasy.net>
Message-ID: <20070430104715.266980@gmx.net>
MIME-Version: 1.0
References: <20070429182209.267430@gmx.net>
 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
 <Pine.LNX.4.58.0704291753370.315@shell2.speakeasy.net>
Subject: Re: Critical points about kernel 2.6.21 and pseudo-authorities
To: Trent Piepho <xyzzy@speakeasy.org>, torvalds@linux-foundation.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+z6GwK7tyziJSwF90Njw5H1tXSsKCzsIfYL56FwD
 ZXWW9w3QQXtpsM5dullzGmlWZEUs7CJzaRfQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: V6BQByQcfW47XD7UCGVohm1udmllcsX2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Sun, 29 Apr 2007 18:37:00 -0700 (PDT)
Von: Trent Piepho <xyzzy@speakeasy.org>
An: Linus Torvalds <torvalds@linux-foundation.org>
CC: Uwe Bugla <uwe.bugla@gmx.de>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mchehab@infradead.org, mkruky@linuxtv.org, linux-dvb@linuxtv.org
Betreff: Re: Critical points about kernel 2.6.21 and pseudo-authorities

> On Sun, 29 Apr 2007, Linus Torvalds wrote:
> > On Sun, 29 Apr 2007, Uwe Bugla wrote:
> >
> > > BUT: This 2.6.21-git2 is unusable in so far as it contains regressive
> code
> > > in the dvb-section, authored by Trent Piepho, acked by Michael Krufky,
> and signed-off-by Mauro Carvalho Chehab:
> >
> > You never explained what the problem even was, apart from compiling in
> > some code that you didn't need to before. Didn't it work in the end?
> >
> > If it worked, I don't see what the big issue was. You are getting a
> _lot_
> > of other code in the kernel that you probably never use, you may not
> even
> > have realized.
> 
> I'd like to explain this a bit, for people seeing these messages who
> haven't
> been following this part of dvb development.
> 
> dvb-pll is a simple driver for a number of I2C tuners, which are used in
> many many TV cards.
> 
> These are simple devices, and drivers for host controllers (which usually
> support quite a few different models of tv card based on the same core
> chip)
> often didn't use dvb-pll.  They would just re-implement an I2C tuner
> driver,
> sometimes more than once in the same file!
> 
> The dvb tree ended up with over a dozen different re-implementations of
> the
> same basic tuner driver.  Of course each implementation would have
> different
> bugs, quirks, and missing features.
> 
> So we've been removing this code and using dvb-pll.  If you look at some
> of
> my patches to do this:
> 
>  14 files changed, 14 insertions(+), 199 deletions(-)
>  1 files changed, 4 insertions(+), 34 deletions(-)
>  4 files changed, 17 insertions(+), 204 deletions(-)
> 
> These patches fixed bugs and added features, yet are very much net
> negative
> when if comes to lines of code in the kernel.
> 
> > any chance to deselect the compilation of the dvb-pll.c-module, as its
> > deselection only works for VIDEO_V4L1_COMPAT, NOT for VIDEO_V4L1.
> 
> dvb-pll has nothing to do with VIDEO_V4L1_COMPAT or VIDEO_V4L1.  Uwe is
> just
> confused about what is causing what.

Hi,
I am NO WAY confused about what is causing what - I only wrote down what I say trying to compile 2.6.21-git2!

Once again, and for the last time definitely, even if you do not want to perceive what goddamn crap you have produced, Mr. Piepho:

If I want to compile drivers for a specific card ( let us call it Pinnacle PCTV SAT or TwinHan DST - just to mention two examples ) I

a. need to say yes to VIEDO_V4L1
b. CANNOT deselect dvb-pll.c (Generic pll) exactly knowing that the PCTV SAT or the TwinHan DST DO NOT need dvb-pll.c.
c. am trapped by still existing exported symbols like "dvb_pll_lg_tdvs_h06xf" in backend module dvb-bt8xx.c (line 614), which have never been a problem before this catastrophic rollback caused by you, Mr. Piepho!
d. do not see any chance to get rid of static dependencies connected with dvb-pll.c because your work is reactionary and a regression, nothing else.

Conclusion:

Linus, I would appreciate you to rip this stuff out of git2, as long as there is no compromise solution that I can live with.

This work, done by Mr. Piepho is very buggy, and buggy stuff like this does not belong into mainline.

> 
> > All the almost excellent work that Michael Krufky has offered for that
> > issue at the transition from 2.6.18 to 2.6.19 or 2.6.20 (do not remeber
> > exactly) is being wiped out and rolled back with his acknowledgement!
> 
> Uwe is probably talking about the dvb_attach() system, written mainly by
> Andrew de Quincey and myself, which went into 2.6.18.  The basic concept
> is
> that a core driver uses symbol_request() to avoid any strong references to
> its helper drivers.  This way only the helper drivers that are actually
> needed must be loaded.  We want to make dvb-pll use this system too, but
> it
> doesn't fully work yet.  I have several ideas about how to solve the
> problem, but it's not a high priority.

YUP. And as long as this is not finished this stuff has absolutely no place in mainline vanilla. Basta!

All you need is to offer a possibility to deselection for dvb-pll.c for cards that never neede it! As lang as you cannot offer this or do not want to offer this there is no place in mainline for that crap work.

The dvb_attach() system worked almost perfectly optimized ( as far as RAM consommation is concerned) for me and a couple of other cards, until you Mr. Piepho, came up and offered this utmost regessive work.

It is a shame that buggy stuff like this can reach the mainline. When I first saw it I could not trust my eyes.

But seeing the complete personal situation @ linuxtv.org - well: Who wonders??
Anything is possible, even if its quality is horrible.

Uwe

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
