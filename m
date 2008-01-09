Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYAIKxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYAIKxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYAIKxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:53:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbYAIKxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:53:09 -0500
Date: Wed, 9 Jan 2008 05:53:04 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: tom@kavaga.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possible 2.6.24-rc7 issue w/respect to pthreads
Message-ID: <20080109105304.GI15450@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <39848.76.189.45.79.1199874932.squirrel@webmail.kavaga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39848.76.189.45.79.1199874932.squirrel@webmail.kavaga.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 02:35:32AM -0800, tom@kavaga.com wrote:
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

Your testcase is buggy.  Detached threads aren't joinable, you can't call
pthread_join on them.

	Jakub
