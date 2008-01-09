Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYAILHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYAILHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYAILH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:07:26 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:53337 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYAILHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:07:25 -0500
Date: Wed, 9 Jan 2008 12:07:22 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: tom@kavaga.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possible 2.6.24-rc7 issue w/respect to pthreads
Message-Id: <20080109120722.262b4eff.dada1@cosmosbay.com>
In-Reply-To: <39848.76.189.45.79.1199874932.squirrel@webmail.kavaga.com>
References: <39848.76.189.45.79.1199874932.squirrel@webmail.kavaga.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 02:35:32 -0800 (PST)
tom@kavaga.com wrote:

> To Whom It May Concern,
> 
> After I patched my 2.6.23 kernel to 2.6.24-rc7 this morning, I noticed
> some odd behavior with respect to POSIX threads in a test program I had
> written (originally to test epoll.)
> 
> The behavior is as follows:
> 
> 1.  main() creates a new thread of execution with pthread_create
> 2.  thread_func() immediately calls pthread_detach(), which is supposed to
> ensure that thread resources are cleaned up when the thread terminates.
> 3.  The spawned thread sleeps and then prints a message "got here"
> 4.  The main thread calls pthread_join().  According to the POSIX
> documentation, this should suspend execution until the spawned thread has
> terminated.
> 
> What I'm seeing is that the main thread terminates immediately.  If I
> comment out the call to pthread_detach(), the program runs normally.  If I
> boot with my 2.6.23 kernel, the program runs normally.
> 
> I'm not sure if this is some oversight on my part but similar programs
> operate correctly on my Debian etch installation with 2.6.18 as well as
> with the newer 23 kernel, but not with the patch.
> 
> If you have any questions, don't hesitate to email me; my address is
> provided below.
> 
> See Attached (bug.c)
> 
> Tom R. Dial
> tom@kavaga.com

Hello Tom

Your program is buggy and depends on scheduling policies.

To make it fails on 2.6.23 (or say 2.6.9) too, just add a sleep(1) before pthread_join() call

Once a thread calls pthread_detach(pthread_t this_id), it's not possible anymore to
pthread_join(this_id, &ret) or effect is undefined.

(quoting POSIX : "The results of multiple simultaneous calls to pthread_join() specifying the same target thread are undefined" )

