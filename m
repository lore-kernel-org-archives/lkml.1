Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZHCSss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZHCSss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZHCSsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:48:46 -0400
Received: from www84.your-server.de ([213.133.104.84]:48386 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZHCSso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:48:44 -0400
Subject: Re: [RFC 0/2] new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <87skg8u51n.fsf@basil.nowhere.org>
References: <1249306755.8358.8.camel@wall-e>
	 <87skg8u51n.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 20:48:41 +0200
Message-Id: <1249325321.3800.15.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 03.08.2009, 20:27 +0200 schrieb Andi Kleen:
> Stefani Seibold <stefani@seibold.net> writes:
> >   the buffer. No extra indirection is needed to access the fifo buffer.
> > - Lockless access: if only one reader and one writer is active on the fifo,
> >   which is the common use case, there is no additional locking necessary.
> 
> Would it also be NMI safe?  I've been looking at a new log buffer
> for MCE/NMI. One option was the fifo in ftrace, but it seems
> so big that it would blow up the machine check code considerably.
> 

Yes, it is. If you have only one reader and one writer there is no
locking necessary.

> There was also an own new fifo that Ying Huang implemented,
> but that one wasn't very popular.
> 
> This might be indeed an alternative. Requirement is NMI-safeness.
> 
> > The API:
> > --------
> >
> > struct kfifo *kfifo_alloc(unsigned long size, gfp_t gfp_mask)
> >  Dynamically allocates a new fifo and returns the address
> >  @size: the size of the internal buffer to be allocated.
> >  @gfp_mask: get_free_pages mask, passed to kmalloc()
> 
> For the MCE use case this would need to be able to optionally use
> bootmem because the first initialization happens too early.
> 

You can use a global variable for your fifo if you like. Or you can
greate a fifo inside a bootmem object. Which this API you have the
freedom of choice ;-)

> -Andi
> 

Stefani


