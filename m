Return-Path: <linux-kernel-owner+w=401wt.eu-S1761851AbYEGRQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851AbYEGRQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYEGRQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:16:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbYEGRQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:16:41 -0400
Date: Wed, 7 May 2008 10:16:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-Id: <20080507101624.5524d3c1.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang>
	<20080506114449.GC32591@elte.hu>
	<20080506120934.GH19219@parisc-linux.org>
	<20080506162332.GI19219@parisc-linux.org>
	<20080506102153.5484c6ac.akpm@linux-foundation.org>
	<20080507163811.GY19219@parisc-linux.org>
	<alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org>
	<alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008 10:08:18 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Which is why I'm 100% convinced it's not even worth saving the old code. 
> It needs to use mutexes, or spinlocks. I bet it has *nothing* to do with 
> "slow path" other than the fact that it gets to that slow path much more 
> these days.

Stupid question: why doesn't lock_kernel() use a mutex?

(stupid answer: it'll trigger might_sleep() checks when we do it early in
boot with irqs disabled, but we can fix that)

(And __might_sleep()'s system_state check might even save us from that)

Of course, we shouldn't change anything until we've worked out why the new
semaphores got slower.

