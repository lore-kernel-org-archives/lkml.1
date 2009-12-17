Return-Path: <linux-kernel-owner+w=401wt.eu-S936734AbZLQSqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936734AbZLQSqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936706AbZLQSqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:46:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33264 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936694AbZLQSp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:45:57 -0500
To: Christoph Hellwig <hch@infradead.org>
Cc: tytso@mit.edu, Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
From: Andi Kleen <andi@firstfloor.org>
References: <20091216043618.GB9104@hera.kernel.org>
	<20091217132256.GO28962@bombadil.infradead.org>
	<alpine.LFD.2.00.0912170811130.15740@localhost.localdomain>
	<20091217163036.GE2123@thunk.org>
	<20091217171025.GB10431@infradead.org>
Date: Thu, 17 Dec 2009 19:45:55 +0100
In-Reply-To: <20091217171025.GB10431@infradead.org> (Christoph Hellwig's message of "Thu, 17 Dec 2009 12:10:25 -0500")
Message-ID: <87zl5hsal8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Dec 17, 2009 at 11:30:36AM -0500, tytso@mit.edu wrote:
>> That's because apparently the iSCSI and DMA blocks assume that they
>> have Real Pages (tm) passed to block I/O requests, and apparently XFS
>> ran into problems when sending vmalloc'ed pages.  I don't know if this
>> is a problem if we pass the bio layer addresses coming from the SLAB
>> allocator, but oral tradition seems to indicate this is problematic,
>> although no one has given me the full chapter and verse explanation
>> about why this is so.
>
> Actually at least iscsi now has a workaround for that by checking for
> PageSlab.  Back when we deal with the XFS issue that check was only
> available with debug options enabled.  I tried to sort it out by
> agreeing with the block and iscsi folks that either

DRBD has the same workaround as well:

        if (disable_sendpage || (page_count(page) < 1) || PageSlab(page))

But it seems like a gross hack to me. Perhaps this should be 
passed as some sort of BIO attribute?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
