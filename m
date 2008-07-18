Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYGRKjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYGRKjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYGRKjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:39:23 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:24747 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbYGRKjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HCsXU98SbpGAmTQi5sqDvRVUO9lfZPyr17jZ5j353DwznweUYSGX8B/+eUOwyWJXFR
         48+E9Qq/pgUwkYzZDQMAZGwLw39J22iBnUYJkaJDDYUQTD6xqbmUustTmKsHYDaMEuuY
         HDTU7V6IcmLbb8lN5R4zFoOkS0qPcrjnDaDkw=
Message-ID: <19f34abd0807180339k4d359fb4sc1cc556567f4f3f3@mail.gmail.com>
Date: Fri, 18 Jul 2008 12:39:18 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: latest -git: A peculiar case of a stuck process (ext3/sched-related?)
Cc: linux-ext4@vger.kernel.org, sct@redhat.com, adilger@sun.com,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080718033225.c141978c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807180245l2a633644n1a8d91cb3587d9e4@mail.gmail.com>
	 <19f34abd0807180317g40a218a2p2bb2857c6f5aa659@mail.gmail.com>
	 <20080718033225.c141978c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 12:32 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 18 Jul 2008 12:17:17 +0200 "Vegard Nossum" <vegard.nossum@gmail.com> wrote:
>
>> And the ext3_find_entry() corresponds to this line:
>>
>>         for (; de < top; de = ext3_next_entry(de)) /* <--- HERE! */
>>         if (ext3_match (namelen, name, de)) {
>>                 if (!ext3_check_dir_entry("ext3_find_entry",
>>                                           dir, de, bh,
>>                           (block<<EXT3_BLOCK_SIZE_BITS(sb))
>>                                   +((char *)de - bh->b_data))) {
>>                         brelse (bh);
>>                         *err = ERR_BAD_DX_DIR;
>>                         goto errout;
>>                 }
>>                 *res_dir = de;
>>                 dx_release (frames);
>>                 return bh;
>>         }
>>
>> Is it possible that this loop can get stuck with a corrupt filesystem image?
>
> yup.  ext2 did that a couple of times.  See the explicit check for
> de->rec_len == 0 in ext2_find_entry().
>
> We fixed one filesystem and forgot the others.  Again.

Wow, that change is OLD, though:

commit aa4f3f285643956bb614cf7b8f88e15f3a375886
Author: Andrew Morton <akpm@zip.com.au>
Date:   Mon Apr 29 23:51:34 2002 -0700

    [PATCH] ext2 directory handling

Will you also send the patch for ext3? :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
