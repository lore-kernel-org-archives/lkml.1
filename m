Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYIERXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYIERXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYIERX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:23:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41642 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYIERX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:23:28 -0400
Date: Fri, 5 Sep 2008 19:26:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: pageexec@freemail.hu, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080905172644.GV18288@one.firstfloor.org>
References: <20080905154221.GF10292@elte.hu> <48C15D0A.6363.4324231@pageexec.freemail.hu> <20080905165239.GA12645@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905165239.GA12645@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


First such checkers already exist -- they are called root kit checkers.
There are various around. 
Usually operate from user space. You could run them in a cron job.

> well at least in the case of Linux we have a fairly good tally of what 
> kernel code is supposed to be executable at some given moment after 
> bootup, and can lock that list down permanently until the next reboot, 
> and give the list to the checker to verify every now and then? Such a 

Doing it in a hypervisor implicitely like Alan proposed would seem much 
stronger and also somewhat cleaner than doing it delayed.

> verification pass certainly wouldnt be cheap though: all kernel 
> pagetables have to be scanned and verified, plus all known code (a few 
> megabytes typically), and the key CPU data structures.

The issue is that a lot of non key data structures all over the memory
have function pointers (or pointers to function pointers) too.
So if you protect syscall table they are just going to patch some dentry
instead. Still if it's reasonable clean it might be still useful to
raise the bar a bit, but I'm not sure a checker qualifies for that.

-Andi
