Return-Path: <linux-kernel-owner+w=401wt.eu-S1764129AbXEZUPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764129AbXEZUPQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 16:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759751AbXEZUPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 16:15:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbXEZUPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 16:15:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Date: Sat, 26 May 2007 22:20:16 +0200
User-Agent: KMail/1.9.5
Cc: nigel@nigel.suspend2.net, Herbert Xu <herbert@gondor.apana.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200705261128.57332.maxi@daemonizer.de> <1180173233.9773.79.camel@nigel.suspend2.net> <200705261449.12823.maxi@daemonizer.de>
In-Reply-To: <200705261449.12823.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705262220.16672.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 26 May 2007 14:49, Maximilian Engelhardt wrote:
> On Saturday 26 May 2007, Nigel Cunningham wrote:
> > Hi.
> >
> > On Sat, 2007-05-26 at 11:28 +0200, Maximilian Engelhardt wrote:
> > > Hello,
> > >
> > > When I try software suspend on my laptop it always returns to my running
> > > system after some time.
> > > This is what's logged by the kernel:
> > >
> > > swsusp: Basic memory bitmaps created
> > > Stopping tasks ...
> > > Stopping kernel threads timed out after 20 seconds (1 tasks refusing to
> > > freeze):
> > >  cryptd
> > > Restarting tasks ... done.
> > > swsusp: Basic memory bitmaps freed
> > >
> > > I have no idea what's the problem, but if you tell me what I should do I
> > > can create debugging information and/or test patches.
> >
> > Could you try this patch, please? It should help.
> >
> > Herbert, is this right? If cryptd is going to be used for block devs,
> > the task should probably be PF_NOFREEZE (or whatever it is today)
> > instead.
> >
> > Regards,
> >
> > Nigel
> >
> >  crypto/cryptd.c         |    1 +
> >  include/linux/freezer.h |    3 +++
> >  kernel/power/process.c  |    2 +-
> >  3 files changed, 5 insertions(+), 1 deletion(-)
> > diff -ruNp 991-fix-cryptd.patch-old/crypto/cryptd.c
> > 991-fix-cryptd.patch-new/crypto/cryptd.c ---
> > 991-fix-cryptd.patch-old/crypto/cryptd.c	2007-05-19 18:16:47.000000000
> > +1000 +++ 991-fix-cryptd.patch-new/crypto/cryptd.c	2007-05-26
> > 19:45:42.000000000 +1000 @@ -341,6 +341,7 @@ static int cryptd_thread(void
> > *data)
> >
> >  		mutex_unlock(&state->mutex);
> >
> > +		try_to_freeze();
> >  		schedule();
> >  	} while (!stop);
> 
> I tried your patch, but when I apply it my kernel doesn't compile any more. I 
> get these warnings/errors:

You need to add '#include <freezer.h>' to crypto/cryptd.c .

Greetings,
Rafael
