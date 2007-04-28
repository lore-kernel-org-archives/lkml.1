Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbXD1JU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbXD1JU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 05:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXD1JU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 05:20:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60717 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161761AbXD1JU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 05:20:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 11:24:56 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280344.49674.rjw@sisk.pl> <20070428085000.GA3293@elf.ucw.cz>
In-Reply-To: <20070428085000.GA3293@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704281124.57106.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 April 2007 10:50, Pavel Machek wrote:
> Hi!
> 
> > > In many ways, "at all".
> > > 
> > > I _do_ realize the IO request queue issues, and that we cannot actually do 
> > > s2ram with some devices in the middle of a DMA. So we want to be able to 
> > > avoid *that*, there's no question about that. And I suspect that stopping 
> > > user threads and then waiting for a sync is practically one of the easier 
> > > ways to do so.
> > > 
> > > So in practice, the "at all" may become a "why freeze kernel threads?" and 
> > > freezing user threads I don't find really objectionable.
> > > 
> > > But as Paul pointed out, Linux on the old powerpc Mac hardware was 
> > > actually rather famous for having working (and reliable) suspend long 
> > > before it worked even remotely reliably on PC's. And they didn't do even
> > > that.
> > > 
> > > (They didn't have ACPI, and they had a much more limited set of devices, 
> > > but the whole process freezer is really about neither of those issues. The 
> > > wild and wacky PC hardware has its problems, but that's _one_ thing we 
> > > can't blame PC hardware for ;)
> > 
> > We freeze user space processes for the reasons that you have quoted above.
> > 
> > Why we freeze kernel threads in there too is a good question, but not for me to
> > answer.  I don't know.  Pavel should know, I think.
> 
> We do not want kernel threads running:
> 
> a) they may hold some locks and deadlock suspend

Yeah, the same issue as with the hibernation and I do think it's _real_.

> b) they may do some writes to disk, leading to corruption

Hmm, is that an issue in the suspend (aka s2ram) case?

> We could solve a) by carefully auditing suspend lock usage to make
> sure deadlocks are impossible even with kernel threads running.

Yes, we can, but for now it's not been done yet.

Greetings,
Rafael
