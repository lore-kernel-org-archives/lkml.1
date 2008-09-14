Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYINHuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYINHuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 03:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbYINHuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 03:50:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbYINHuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 03:50:01 -0400
Date: Sun, 14 Sep 2008 00:44:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [lockdep] possible circular locking, between &mm->mmap_sem and
 &dev->ev_mutex
Message-Id: <20080914004442.4f8e851f.akpm@linux-foundation.org>
In-Reply-To: <20080914073906.GA6184@elte.hu>
References: <20080910113717.GB16811@wotan.suse.de>
	<1221046892.30429.85.camel@twins.programming.kicks-ass.net>
	<20080910114755.GA9696@elte.hu>
	<20080910121217.GA16013@elte.hu>
	<20080910144812.GB18644@wotan.suse.de>
	<1221058864.30429.291.camel@twins.programming.kicks-ass.net>
	<20080910152651.GE18644@wotan.suse.de>
	<20080911082709.GA14378@elte.hu>
	<20080914073906.GA6184@elte.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep 2008 09:39:06 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> with the new mmap_sem lockdep annotations, -tip testing found a third 
> lockdep assert, see below. Config attached.
> 
> 	Ingo
> 
> ----------------->
> [ 6460.634452] 
> [ 6460.634465] =======================================================
> [ 6460.634494] [ INFO: possible circular locking dependency detected ]
> [ 6460.634517] 2.6.27-rc6-tip-00290-g8e229c3-dirty #1
> [ 6460.634535] -------------------------------------------------------
> [ 6460.634555] gdm-simple-gree/4778 is trying to acquire lock:
> [ 6460.634574]  (&mm->mmap_sem){----}, at: [<c018fe33>] might_fault+0x36/0x73
> [ 6460.634639] 
> [ 6460.634645] but task is already holding lock:
> [ 6460.634662]  (&dev->ev_mutex){--..}, at: [<c01c7a76>] inotify_read+0xd8/0x16e
> [ 6460.634715] 
> [ 6460.634721] which lock already depends on the new lock.

Yes, there's a thread in my intray called "inotify_read's ev_mutex vs
do_page_fault's mmap_sem...".  It's a bit flakey-looking, but there's a
patch in there.

