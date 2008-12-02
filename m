Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYLBK1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYLBK1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLBK1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:27:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39731 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYLBK1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:27:32 -0500
Subject: Re: MAP_PRIVATE that stays private even on external write
From: Peter Zijlstra <peterz@infradead.org>
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
In-Reply-To: <493508b5$0$200$e4fe514c@news.xs4all.nl>
References: <493508b5$0$200$e4fe514c@news.xs4all.nl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Dec 2008 11:27:31 +0100
Message-Id: <1228213651.7133.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 10:06 +0000, Miquel van Smoorenburg wrote:
> I have an application that mmaps blocks from a file and then
> sends it out over a TCP socket.
> 
> The contents of the file may be overwritten while the blocks
> are sent out, but there is a very low chance of that.
> 
> To prevent this, I can ofcourse just use read() all blocks into
> memory in advance, check consistency, and go ahead .. but since
> there may be a lot of network connections active this might cost
> a lot of memory.
> 
> What I am looking for is a MAP_PRIVATE type flag that, when another
> process modifies pages of the file (through mmap() or write())
> makes sure that my mapping never sees that.
> 
> I found out that mmap(MAP_PRIVATE|MAP_POPULATE) does exactly what
> I want, but ofcourse it reads in the entire mapping all at once,
> which is equivalent to plain read().
> 
> There has been talk of a MAP_SNAPSHOT flag before, e.g.
> http://lkml.indiana.edu/hypermail/linux/kernel/0407.1/0416.htm
> 
> Has anyone ever looked at implementing something like this ?

I suppose that needs a snapshot filesystem for backing, and we don't
have such a creature (yet). I suppose BTRFS might be able to pull that
off.
