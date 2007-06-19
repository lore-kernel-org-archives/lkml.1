Return-Path: <linux-kernel-owner+w=401wt.eu-S1765472AbXFSUPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765472AbXFSUPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761291AbXFSUPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:15:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51072 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755091AbXFSUO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:14:59 -0400
Date: Tue, 19 Jun 2007 13:14:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/2] UML - Add stack usage monitoring
Message-Id: <20070619131441.01b5ae4b.akpm@linux-foundation.org>
In-Reply-To: <20070619195003.GA11718@c2.user-mode-linux.org>
References: <20070619184245.GA10567@c2.user-mode-linux.org>
	<20070619115422.de61abd5.akpm@linux-foundation.org>
	<20070619195003.GA11718@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 15:50:03 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> On Tue, Jun 19, 2007 at 11:54:22AM -0700, Andrew Morton wrote:
> > On Tue, 19 Jun 2007 14:42:45 -0400
> > Jeff Dike <jdike@addtoit.com> wrote:
> > 
> > > Add a machanism to see how much of a kernel stack is used.  This
> > > allocates zeroed stacks and sees where the lowest non-zero byte is on
> > > process exit.  It keeps track of the lowest value and logs values as
> > > they get lower.
> > > 
> > 
> > remind us again why the generic code is unsuitable?
> 
> It does something different - it will tell you the greatest stack
> usage of any currently running process.  What I want to be able to do
> is run a workload and come back a few days later and see how close
> anything came to running out of stack.

<looks>

wth?  I'm _sure_ we used to have code in there which would, within
do_exit(), work out the maximum amount of kernel stack which a task had
used and if that was max-since-boot, drop a printk.

Maybe I dreamed it, but I don't think so.

I wonder where it went?

Oh well.  Your new code should really be generic, utilising the
stack-page-zeroing which CONFIG_DEBUG_STACK_USAGE enables.  There's nothing
UML-specific about it.

low_water_lock and lowest_to_date should be static to check_stack_usage(),
btw..

