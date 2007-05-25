Return-Path: <linux-kernel-owner+w=401wt.eu-S1763423AbXEYQU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763423AbXEYQU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbXEYQUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:20:16 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbXEYQUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:20:14 -0400
Date: Fri, 25 May 2007 09:19:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Romano Giannetti <romanol@upcomillas.es>
cc: linux-kernel@vger.kernel.org
Subject: Re: Long delay in resume from RAM (Was Re: [patch 
 00/69]-stablereview)
In-Reply-To: <1180084976.31495.15.camel@localhost>
Message-ID: <alpine.LFD.0.98.0705250913350.26602@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>  <4652070D.3090509@redhat.com>
  <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org> 
 <20070521212522.GL3429@sequoia.sous-sol.org>  <1179870110.16656.2.camel@localhost>
  <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> 
 <1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost>
  <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org> 
 <1180044888.15241.39.camel@localhost>  <alpine.LFD.0.98.0705241549130.26602@woody.linux-foundation.org>
 <1180084976.31495.15.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Romano Giannetti wrote:
> 
> ...and while at it, I decided to start by learning a bit more of git,
> and installed the last version...
> 
> % git clone http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6
> Initialized empty Git repository in /usr/src/git/linux-2.6/.git/
> Cannot get remote repository information.
> Perhaps git-update-server-info needs to be run there?

Heh. If you are using http://, you should _not_ ask for "git.kernel.org".

So use

	git clone http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6

instead. That should work (modulo mirroring issues - but mirroring has 
worked pretty well lately)

> I cannot use git protocol from here (overfirewalling, you know...)

http:// will suck, but should work. It will be a bit frustrating, because 
when it downloads the big packs, it will just say something like

	Getting pack 4f22c0234340c4f3470c04f912969fc59ae8babc
	 which contains ...

and then it will be quiet for a _loong_ time while it downloads that 164MB 
pack..

And the real problem with http:// will come later, if you use git to keep 
up-to-date with the kernel, and I end up repacking the archive (which I 
usually do around major releases). Then it will end up fetching the newly 
repacked data - even though most of it you already have.

Anyway, there's a reason why the "native" protocols are much preferred, 
but the http:// one does work. It just requires www.kernel.org, not 
git.kernel.org.

			Linus
