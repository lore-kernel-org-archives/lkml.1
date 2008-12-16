Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbYLPStD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYLPStD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:49:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYLPSsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:48:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259AbYLPSsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:48:52 -0500
Date: Tue, 16 Dec 2008 10:48:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: GIT head doesn't seem to want to build on 32bit..
In-Reply-To: <20081216181133.2342b49e@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0812161043240.14014@localhost.localdomain>
References: <20081216172859.5bc030b6@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0812160946410.14014@localhost.localdomain> <20081216181133.2342b49e@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Dec 2008, Alan Cox wrote:
> 
> I built a 64bit kernel from the same source tree first, then did make
> mrproper, then it broke. I'll investigate further.

Maybe you did just "make clean"? That leaves at least the "include/asm" 
symlink around. 

But maybe there is some other file that "make mrproper" doesn't actually 
remove and that gets generated with your 64-bit config or build, but not 
mine. You can always test with doing a

	git ls-files -o

to see if there are any "other" files (ie build-generated ones) around.

(On that same vein: I have taught my fingers to just do "git clean -dqfx" 
instead of "make distclean". Works with any git repository, and avoids any 
makefile bugs that leave generated files behind).

			Linus
