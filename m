Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbYDKU3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbYDKU3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759544AbYDKU26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:28:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57022 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759431AbYDKU25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:28:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: x86 git tree broken (bisected)
Date: Fri, 11 Apr 2008 22:29:21 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Yinghai Lu <yinghai.lu@sun.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
References: <200804102159.14563.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl> <200804112223.14160.rjw@sisk.pl>
In-Reply-To: <200804112223.14160.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804112229.22424.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 of April 2008, Rafael J. Wysocki wrote:
> On Friday, 11 of April 2008, Rafael J. Wysocki wrote:
> > On Friday, 11 of April 2008, Rafael J. Wysocki wrote:
> > > On Thursday, 10 of April 2008, Ingo Molnar wrote:
> > > > 
> > > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > > > > > First, the X server doesn't want to start (it says it couldn't 
> > > > > > > > mmap the framebuffer).
> > > > > > > 
> > > > > > > could you send your .config?
> > > > > > 
> > > > > > Attached.
> > > > > 
> > > > > could you disable this option:
> > > > > 
> > > > >  CONFIG_NONPROMISC_DEVMEM=y
> > > > > 
> > > > > does it help with the X problem?
> > > 
> > > That didn't help.
> > > 
> > > > btw., Xorg works fine here on a comparable AMD system - but i use a 
> > > > rather new distro (Fedora 8) which has Xorg 7.2.
> > > 
> > > My system is an OpenSUSE 10.3 and it has Xorg 7.2 as well.
> > > 
> > > I think the problem is somehow related to the Radeon.
> > 
> > The bisection turned up commit ea1441bdf53692c3dc1fd2658addcf1205629661
> > "x86: use bus conf in NB conf fun1 to get bus range on, on 64-bit"  as the one
> > causing problems.
> > 
> > Unfortunately, I can't revert cleanly it, because there are two more commits
> > depending on it in a highly nontrivial fashion, so I have reverted all three
> > commits
> > 
> > a365998cd2cecfb827469dbd57c29602c106cb83
> > 44f7f90fbe7a3a99aab082f765346514b7b5c705
> > ea1441bdf53692c3dc1fd2658addcf1205629661
> > 
> > and X starts again.  Also, suspend to RAM works from under X.
> 
> Update:
> 
> With the above three commits reverted both X itself and suspend to RAM from
> X also work with the current x86-git (as of HEAD equal to
> 1192aeb957402b45f311895f124e4ca41206843c).

That also works from under a framebuffer console, so one of these commits
(presumably ea1441bdf53692c3dc1fd2658addcf1205629661) also breaks suspend on
this box.

Thanks,
Rafael
