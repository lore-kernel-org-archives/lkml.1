Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZF1Uxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZF1Uxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 16:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZF1UxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 16:53:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751729AbZF1UxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 16:53:24 -0400
Date: Sun, 28 Jun 2009 13:52:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Oleg Nesterov <oleg@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when using
 pipes in core_pattern
Message-Id: <20090628135235.10f9b153.akpm@linux-foundation.org>
In-Reply-To: <20090628193112.GA6760@one.firstfloor.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
	<20090625163050.d6a71a13.akpm@linux-foundation.org>
	<20090626104804.GA7337@hmsreliant.think-freely.org>
	<20090626092001.32e35e17.akpm@linux-foundation.org>
	<20090628193112.GA6760@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 21:31:12 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> > One way would be to add a new sysctl-externs.h and then put all the
> > declarations in there.  That file gets included by sysctl.c and by each
> > file which shares a global with sysctl.c
> 
> Long ago I had a experimental patch to put sysctls into a new ELF section. The 
> you could simply put a DEFINE_SYSCTL(....) into the appropiate source file
> which defined the variable and most of the tables went.
> 
> No externs, no mess, no patch collisions, everything much nicer.
> 
> The only problem was that it didn't support the numerical sysctl
> space, so that would need to be removed first.
> 
> It's deprecated for quite some time now:
> 
>   if (msg_count < 5) {
>                 msg_count++;
>                 printk(KERN_INFO
>                         "warning: process `%s' used the deprecated sysctl "
>                         "system call with ", current->comm);
> 
> Should it finally go now? If yes I could polish up the old patch again.
> 

I suspect that it will be a long time before we can actually remove the
numerical sysctl support, if ever.  In _theory_ we should support it
for ever.  But in practice, we could probably remove it with a minimum
of disruption a few years hence, but it's hard to work this out.

When was the last time we saw a "warning: process `%s' used the
obsolete bdflush system call" warning?  A quick google here says 2004. 
Is that data?  A bit, I guess.

Maybe Eric has thought about this issue?
