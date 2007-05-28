Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbXE1E7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbXE1E7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 00:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXE1E7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 00:59:10 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:31208 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750844AbXE1E7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 00:59:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=dMJ/WRtbU5a/t3vO+XgtZxRAhvHJFoZqpJOIqY8urYiHc4NGh1cQTRXH4pLqU7bfBXUny64xHDzwxTmQEJ8/EmEy3m18eMsvK6eo2xUHjf4hIxP9vBw1pnQWtas2e4Gfm7BMngmZN8jQ4LE1YHi/uFYjSKtCJhWak/5CZ3IzDes=  ;
X-YMail-OSG: Cx5Fp2QVM1k5fvRJIhYK3D1EAwdoTNBu4a_ezROmY5x.iR9HdmEgdveOM_0ca8Kg1orpoo9YBQ--
Message-ID: <465A6197.5010402@yahoo.com.au>
Date: Mon, 28 May 2007 14:59:03 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Preserve the dirty bit in init_page_buffers
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>	<465A55E7.50904@yahoo.com.au> <m18xb9a7sy.fsf@ebiederm.dsl.xmission.com> <465A6078.6010804@yahoo.com.au>
In-Reply-To: <465A6078.6010804@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Eric W. Biederman wrote:

>> When we initialize the ramdisk by writing to /dev/ram0 usually in
>> init/do_mounts_rd.c we don't allocate buffer heads but we do set
>> the dirty bit, and the page is in the page cache.  So when we
>> later call getblk it reuses the same page and then calls
>> init_page_buffers.
> 
> 
> Hmm, so this would be a problem for block_dev.c as well, then?
> Because it would be possible to have a dirty block dev page
> have its buffers reclaimed and then reinitialised via
> init_page_buffers, AFAIKS.

Oh, no, try_to_free_buffers won't drop dirty buffers. However we
could still set_page_dirty of a block device page without buffers
via an mmap.

-- 
SUSE Labs, Novell Inc.
