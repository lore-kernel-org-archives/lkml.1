Return-Path: <linux-kernel-owner+w=401wt.eu-S1763959AbXE2FOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763959AbXE2FOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 01:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbXE2FOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 01:14:48 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:27414 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753814AbXE2FOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 01:14:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=l9AlQIbp0nTCqLtaiRFdXGD+83GZLjHB/7Lgx/La3Rdr35e7jAbtKh0KF2IUqvqks1NwKIGOwvTyoMvoqFh3VKDvGiWEiPZUGa+mt+Z3grgFM2DY9FDY/VzL2E56/f3GwMyqi5VcIhF+XjLLK8qjmZRKKVG6hX68yc0Aoo1L3UU=  ;
X-YMail-OSG: QbSnIfIVM1nw6zA7dD_HyTvVnHg5Uv_h1jEqsHDJQKhGdJbEJZJLB9uXe1ZRGgkAsn2ZL2VImw--
Message-ID: <465BB6C2.7050704@yahoo.com.au>
Date: Tue, 29 May 2007 15:14:42 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Preserve the dirty bit in init_page_buffers
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>	<465A55E7.50904@yahoo.com.au>	<m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>	<465A6078.6010804@yahoo.com.au> <465A6197.5010402@yahoo.com.au> <m1veed82mz.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1veed82mz.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:

>> However we
>>could still set_page_dirty of a block device page without buffers
>>via an mmap.
> 
> 
> After the page is made dirty via mmap we have:
> sys_write -> ... -> block_prepare_write -> ... -> create_empty_buffers.

Yep, that's what I mean.


> I suspect that is a pretty rare case but it does indeed seem to exist
> as a problem.

I think so too. But either we have some misunderstanding of the
codepaths involved, or the author of the comments there didn't
consider this case, so...

-- 
SUSE Labs, Novell Inc.
