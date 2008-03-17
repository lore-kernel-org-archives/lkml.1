Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbYCQHOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbYCQHOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 03:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYCQHOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 03:14:37 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:62247 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbYCQHOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 03:14:34 -0400
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Adam Megacz <adam@megacz.com>, linux-kernel@vger.kernel.org
Subject: Re: question about PAE and buffercache
References: <x3abl3sjf5.fsf@nowhere.com>
	<200803171327.45159.nickpiggin@yahoo.com.au>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Mar 2008 08:14:30 +0100
In-Reply-To: <200803171327.45159.nickpiggin@yahoo.com.au>
Message-ID: <87lk4hizzd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Mar 2008 07:07:57.0001 (UTC) FILETIME=[A08B2B90:01C887FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Thursday 13 March 2008 08:48, Adam Megacz wrote:
> > Sorry to ask here, but I looked around for quite a while on the web.
> >
> > Is the size of the buffercache in any way constrained by the amount of
> > virtual memory space allocated to the kernel (when using a PAE kernel)?
> >
> > For example with a 1G/3G split and 8G of physical memory, if userspace
> > processes aren't interested in more than 6G of that memory, would the
> > kernel fully utilize all of the remaining 2G for buffercache?
> 
> No. It is indeed constrained by the amount of virtual memory space
> the kernel has. So it could use in practice probably only around
> 700-800MB for buffercache.

I suspect Adam has a terminology problem and he likely meant "unmapped
page cache" instead of buffer cache.

In Linux "buffer cache" only refers to file system
metadata (like file system bitmaps etc.), but he likely meant 
all file data which is in the page cache. The page cache is not 
limited by the kernel virtual memory split. In fact buffer
cache is a special case of the page cache too

iirc even large parts of the buffer cache can be highmem
depending on the file system.

-Andi
 
