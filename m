Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbYKFA5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbYKFA5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYKFA5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:57:06 -0500
Received: from smtp-out.google.com ([216.239.33.17]:15084 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbYKFA5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:57:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=ZXvXCfbOwAOP1fQt2dvz43OxyhbirQUoNoubqwM1+dgads14Zg/lMzJQMiREmfqIx
	xzMkbko0hSNcDCWL4TRrQ==
MIME-Version: 1.0
In-Reply-To: <20081101022128.3f8a535c.akpm@linux-foundation.org>
References: <1786ab030810311354h1a7c8fb0q1267969d432f521c@mail.gmail.com>
	 <20081101022128.3f8a535c.akpm@linux-foundation.org>
Date: Wed, 5 Nov 2008 16:56:54 -0800
Message-ID: <1786ab030811051656r7cc09fcakbf485c3b0663757@mail.gmail.com>
Subject: Re: Metadata in sys_sync_file_range and fadvise(DONTNEED)
From: Chad Talbott <ctalbott@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2008 at 1:21 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> And fadvise(FADV_DONTNEED) is just that: "I won't be using that data
> again".  Implementing specific writeback behaviour underneath that hint
> is unobvious and a bit weird.  It's a bit of a fluke that it does
> writeout at all!
>
> We have much more flexibility with sync_file_range(), and it is more
> explicit.

So in the new world, an application should call sync_file_range
(solving my problem by including metadata) to initiate writeout, and
then call posix_fadvise(DONTNEED) to drop the pages from page cache?
I think this would work for me.

> That being said, I don't understand why the IO scheduling problems
> which you're seeing are occurring.  There is code in fs/mpage.c
> specifically to handle this case (search for "write_boundary_block").
> It will spot that 4k indirect block in the middle of two 4MB data
> blocks and will schedule it for writeout at the right time.
>
> So why isn't that working?

Very good question, I'll look into why it's not helping here.

Chad
