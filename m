Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbXE0S1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbXE0S1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 14:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbXE0S05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 14:26:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54160 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbXE0S05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 14:26:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Date: Sun, 27 May 2007 20:32:14 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org> <20070527164300.GA20355@srcf.ucam.org>
In-Reply-To: <20070527164300.GA20355@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705272032.15971.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 27 May 2007 18:43, Matthew Garrett wrote:
> On Sun, May 27, 2007 at 09:26:00AM -0700, Linus Torvalds wrote:
> 
> > And by "disabling the freezer", I think we should just not call it at all. 
> > However, sadly, right now it's called from common code. I'll happily take 
> > a tested patch to split that code sequence up, and try to do it in 2.6.23, 
> > if somebody has the energy (I'm getting to the point where I may just do 
> > it myself, but my lazy nature still hopes for a STR person to step 
> > forward).
> 
> I'll take a look at this. It probably makes sense to build on Rafael's 
> work on splitting the codepaths up.

Actaully, removing the freezer from the suspend code path is simple.  You only
need to remove calls to freeze_processes() and thaw_processes() from
kernel/power/main.c .

That said, I don't think that PPC does what you say only.  We've discussed this
a bit on linux-pm, in this thread:

https://lists.linux-foundation.org/pipermail/linux-pm/2007-May/012242.html

In particular, please see this message:

https://lists.linux-foundation.org/pipermail/linux-pm/2007-May/012301.html

Greetings,
Rafael
