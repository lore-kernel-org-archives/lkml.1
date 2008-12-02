Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYLBOej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYLBOej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 09:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYLBOe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 09:34:29 -0500
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1830 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYLBOe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 09:34:28 -0500
Subject: Re: MAP_PRIVATE that stays private even on external write
From: Miquel van Smoorenburg <miquels@cistron.nl>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
In-Reply-To: <1228213651.7133.12.camel@twins>
References: <493508b5$0$200$e4fe514c@news.xs4all.nl>
	 <1228213651.7133.12.camel@twins>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 15:34:12 +0100
Message-Id: <1228228452.24000.118.camel@n2o.xs4all.nl>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 11:27 +0100, Peter Zijlstra wrote:
> On Tue, 2008-12-02 at 10:06 +0000, Miquel van Smoorenburg wrote:
> > What I am looking for is a MAP_PRIVATE type flag that, when another
> > process modifies pages of the file (through mmap() or write())
> > makes sure that my mapping never sees that.
> > 
> > There has been talk of a MAP_SNAPSHOT flag before, e.g.
> > http://lkml.indiana.edu/hypermail/linux/kernel/0407.1/0416.htm
> > 
> > Has anyone ever looked at implementing something like this ?
> 
> I suppose that needs a snapshot filesystem for backing, and we don't
> have such a creature (yet). I suppose BTRFS might be able to pull that
> off.

That is a different way of looking at it. Interesting.

It won't help me though, as the "file" I was talking about is in
fact /dev/sdb .

But the current MAP_PRIVATE doesn't need a versioning filesystem either.
It's just that if you write to the mapping, that never gets visible in
other mappings of the same file, nor in the file itself.

I'd like to see something like that, but the other way around. If the
file is modified through a different mapping or write(), modifications
show up in the file and other shared mappings but not in my private
mapping. A copy-on-write, but slightly different in what is copied.

Since MAP_PRIVATE|MAP_POPULATE appears to do this, I thought that
perhaps there is enough infrastructure to do something similar without
MAP_POPULATE, but I really don't know enough of mm/* .

Mike.

