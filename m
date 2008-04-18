Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbYDRTA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbYDRTA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 15:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbYDRTAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 15:00:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754772AbYDRTAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 15:00:09 -0400
Date: Fri, 18 Apr 2008 11:59:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: netdev@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] /dev/vring: simple userspace-kernel ringbuffer
 interface.
Message-Id: <20080418115959.6b8fdfa7.akpm@linux-foundation.org>
In-Reply-To: <200804190032.39626.rusty@rustcorp.com.au>
References: <200804181433.48488.rusty@rustcorp.com.au>
	<200804181439.49051.rusty@rustcorp.com.au>
	<20080418041846.db15150b.akpm@linux-foundation.org>
	<200804190032.39626.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008 00:32:39 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> > Isn't this kinda-sorta like what a relayfs file does?  The oprofile
> > buffers?  etc?  Nothing in common at all, no hope?
> 
> An excellent question, but I thought the modern kernel etiquette was to only 
> comment on whitespace and formatting, and call it "review"? :)
> 
> Yes, kinda-sorta in that it's a ring buffer.  No, in that it's bidir and 
> consumption can be out-of-order (kind of important for I/O buffers).
> 
> But the reason I'm not proposing it as a syscall is that I'm not convinced 
> it's the One True Solution which everyone should be using.  Time will tell: 
> it's clearly not tied to tun and it's been generically useful for virtual 
> I/O, but history has not been kind to new userspace interfaces.

This is may be our third high-bandwidth user/kernel interface to transport
bulk data ("hbukittbd") which was implemented because its predecessors
weren't quite right.  In a year or two's time someone else will need a
hbukittbd and will find that the existing three aren't quite right and will
give us another one.  One day we need to stop doing this ;)

It could be that this person will look at Rusty's hbukittbd and find that
it _could_ be tweaked to do what he wants, but it's already shipping and
it's part of the kernel API and hence can't be made to do what he wants.

So I think it would be good to plonk the proposed interface on the table
and have a poke at it.  Is it compat-safe?  Is it extensible in a
backward-compatible fashion?  Are there future-safe changes we should make
to it?  Can Michael Kerrisk understand, review and document it?  etc.

You know what I'm saying ;)  What is the proposed interface?
