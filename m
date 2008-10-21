Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYJUUlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYJUUlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYJUUlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:41:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34204 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYJUUlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:41:12 -0400
Subject: Re: [RFC v7][PATCH 0/9] Kernel based checkpoint/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oren Laadan <orenl@cs.columbia.edu>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, hpa@zytor.com,
       tglx@linutronix.de, torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20081021122135.4bce362c.akpm@linux-foundation.org>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>
	 <20081021122135.4bce362c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 13:41:07 -0700
Message-Id: <1224621667.1848.228.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 12:21 -0700, Andrew Morton wrote:
> On Mon, 20 Oct 2008 01:40:28 -0400
> Oren Laadan <orenl@cs.columbia.edu> wrote:
> > These patches implement basic checkpoint-restart [CR]. This version
> > (v7) supports basic tasks with simple private memory, and open files
> > (regular files and directories only).
> 
> - how useful is this code as it stands in real-world usage?

Right now, an application must be specifically written to use these mew
system calls.  It must be a single process and not share any resources
with other processes.  The only file descriptors that may be open are
simple files and may not include sockets or pipes.

What this means in practice is that it is useful for a simple app doing
computational work.

> - what additional work needs to be done to it?  (important!)
> 
> - how far are we down the design and implementation path with that new
>   work?

We know this design can work.  We have two commercial products and a
horde of academic projects doing it today using this basic design.
We're early in this particular implementation because we're trying to
release early and often.

I think we're at the point where we need a yes or no from the rest of
the community on it.  Reading the patches, I'd hope a reviewer can get
an idea how this will extend to other subsystems.  Do you think the
current patches aren't enough from which to extrapolate how this will be
extended?

> Are we yet at least in a position where we can say "yes, this
> feature can be completed and no, it won't be a horrid mess"?

It will be complete a few months after the rest of the kernel is
complete. :)

>From these patches, I think you can see that this will largely be
something that can live off in its own corner of the tree.  We will, of
course, need to do plenty of refactoring of existing code (like the pid
namespaces for instance) to make some of it more accessible from the
outside.  We're also going to look for every opportunity to share code
with other users like the freezer.

-- Dave

