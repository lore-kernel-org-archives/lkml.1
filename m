Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYGXT3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYGXT3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYGXT3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:29:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbYGXT3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:29:08 -0400
Date: Thu, 24 Jul 2008 12:22:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: pHilipp Zabel <philipp.zabel@gmail.com>
cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Chuck Wolber <chuckw@quantumlinux.com>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Jake Edge <jake@lwn.net>, Michael Krufky <mkrufky@linuxtv.org>,
       stable@kernel.org, Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [stable] [patch 44/47] pxamci: fix byte aligned DMA transfers
In-Reply-To: <74d0deb30807240333l565eaf24uf695ce8d01597090@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807241219480.3237@nehalem.linux-foundation.org>
References: <20080722230208.148102983@mini.kroah.org>  <20080722231342.GA8282@suse.de> <20080722231735.GS8282@suse.de>  <74d0deb30807230001x176e375cq9a8060c20596f36f@mail.gmail.com>  <20080723201258.GA26156@kroah.com>  <alpine.LFD.1.10.0807231322250.4754@woody.linux-foundation.org>
  <20080723203250.GA26454@kroah.com> <74d0deb30807240333l565eaf24uf695ce8d01597090@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Jul 2008, pHilipp Zabel wrote:
> > On Wed, Jul 23, 2008 at 01:24:12PM -0700, Linus Torvalds wrote:
> >>
> >> Hmm. I think it's commit 4fe16897c59882420d66f2d503106653d026ed6c
> >> upstream. I don't know why it has a different SHA1 in the mmc tree, but I
> >> assume that it's because the MMC tree has rebased at some point. Ugh.
> 
> Thank you, I think when I wrote my mail it wasn't pulled yet.

Pulling doesn't change the SHA1 ID of a commit, so _if_ it had been stable 
in the -mmc tree, it would have had the same commit in the kernel too. 
That's very much a design issue in git: the same commit always has the 
same ID. _ALWAYS_.

So the fact that the ID changed implies that something odd happened in the 
-mmc tree. Most likely a rebase. And again, this implies that somebody 
rebased already-public commits, since otherwise nobody would have ever 
even seen the original SHA1 ID. 

Which is not good behaviour, _exactly_ because it makes it much harder for 
people to work together - suddenly a commit that got reported (for 
whatever reason: bug-report or 'please backport', it's all the same issue 
in the end) no longer exists.

		Linus
