Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbYJITqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbYJITqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbYJITqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:46:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572AbYJITqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:46:46 -0400
Date: Thu, 9 Oct 2008 12:46:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Building a tracing userspace tool in the kernel tree
Message-Id: <20081009124602.21a9b463.akpm@linux-foundation.org>
In-Reply-To: <20081009191626.GA29344@Krystal>
References: <20081009191626.GA29344@Krystal>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008 15:16:26 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi Sam,
> 
> At the kernel summit, people seemed to be interested to have the basic
> userspace tools required to extract and pretty-print a trace available
> within the kernel tree. Therefore, what I am trying to do is something
> along the lines of
> 
> ltt/usr/
> ltt/usr/tracectl/    (control tracing)
> ltt/usr/tracesplice/ (splice buffers to disk)
> ltt/usr/tracecat/    (merge sort and format the binary buffers into
>                       human-readable text)
> 
> That would however require to create a Makefile which behaves a little
> bit like what scripts/ is currently doing with hostprogs-y, only that
> it's different in the sense that those tools are not required to build
> the kernel and this could therefore become a more standard part of the
> build process than what scripts/ is.
> 
> Is there some magic statements to put in Makefile and ltt/Makefile to
> get this to build nicely with the rest of the tree ?
> 

Sam's git://git.kernel.org/pub/scm/linux/kernel/git/sam/test.git#master
tree contains a tests/ directory in which various userspace things are
compiled.  I'd suggest you build on top of that.

Sam, this tells us that what you have there is insufficiently general. 
Mathieu's tracing thing isn't a "test", but it's userspace.  We should
have

	./userspace/tests/
	./userspace/ltt/

no?
