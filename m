Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbYJ1FHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbYJ1FHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYJ1FHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:07:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbYJ1FHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:07:36 -0400
Date: Mon, 27 Oct 2008 22:06:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: trace: fix printk warning for u64
Message-Id: <20081027220655.1d188e1d.akpm@linux-foundation.org>
In-Reply-To: <20081028001254.7cb224e9.sfr@canb.auug.org.au>
References: <20081027174328.084649ab.sfr@canb.auug.org.au>
	<20081027095248.GA6969@elte.hu>
	<20081028001254.7cb224e9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 00:12:54 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Mon, 27 Oct 2008 10:52:48 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > (btw., did the "unify u64 definitions across all platforms" project 
> > get anywhere?)
> 
> I think (from a comment from DaveM) that it led into a real mess.

The problem is the large amount of arch-specific code which is printing
u64's with %lu because it "knows" that u64 is implemented as ulong. 
They all need to be switched to %ll.

A better strategy to get all this done would be to convert the
offending architectures to `long long' individually.  Then when that's
all done, unifying the typedef is a trivial step.
