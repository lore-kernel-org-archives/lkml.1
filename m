Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbYEQV7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbYEQV7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 17:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759830AbYEQV65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 17:58:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759813AbYEQV65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 17:58:57 -0400
Date: Sat, 17 May 2008 14:58:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] char dev BKL pushdown 
In-Reply-To: <16082.1210952646@vena.lwn.net>
Message-ID: <alpine.LFD.1.10.0805171452340.3020@woody.linux-foundation.org>
References: <16082.1210952646@vena.lwn.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Btw, Jonathan, would you be willing to maintain some kind of tree of these 
BKL removal patches? 

This is different from the work Ingo is doing in the sense that these 
things should be (a) safe and reasonably obvious and thus (b) presumably 
ready to be merged in the next merge window. Ingo's BKL debugging tree is 
likely a good thing to use to find places that need work, but actually 
removing the BKL from some subsystem is a different issue.

(And when I say "safe and reasonably obvious" I obviously don't mean that 
there can't be bugs. Mistakes happen, and some BKL use might be overly 
subtle like the issue that Alan pointed out with an empty ->open routine 
almost accidentally serializing with initialization, but that's why I'd 
not merge these things after -rc2 anyway, but in the next merge window).

Because if you're willing to maintain a BKL-cleanup tree that gets merged 
into linux-next etc, I'd submit my VFAT/MSDOS BKL removal patch to you. 
The reason I did that one was that Thomas actually reported that to be a 
major source of latency problems on one of his embedded systems (80ms 
latency!), so it would be nice to have that patch in some place where it 
might get tested.

		Linus
