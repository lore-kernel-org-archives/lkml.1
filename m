Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYGRKdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYGRKdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYGRKda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:33:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbYGRKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:33:29 -0400
Date: Fri, 18 Jul 2008 03:32:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: linux-ext4@vger.kernel.org, sct@redhat.com, adilger@sun.com,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: latest -git: A peculiar case of a stuck process
 (ext3/sched-related?)
Message-Id: <20080718033225.c141978c.akpm@linux-foundation.org>
In-Reply-To: <19f34abd0807180317g40a218a2p2bb2857c6f5aa659@mail.gmail.com>
References: <19f34abd0807180245l2a633644n1a8d91cb3587d9e4@mail.gmail.com>
	<19f34abd0807180317g40a218a2p2bb2857c6f5aa659@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 12:17:17 +0200 "Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> And the ext3_find_entry() corresponds to this line:
> 
>         for (; de < top; de = ext3_next_entry(de)) /* <--- HERE! */
>         if (ext3_match (namelen, name, de)) {
>                 if (!ext3_check_dir_entry("ext3_find_entry",
>                                           dir, de, bh,
>                           (block<<EXT3_BLOCK_SIZE_BITS(sb))
>                                   +((char *)de - bh->b_data))) {
>                         brelse (bh);
>                         *err = ERR_BAD_DX_DIR;
>                         goto errout;
>                 }
>                 *res_dir = de;
>                 dx_release (frames);
>                 return bh;
>         }
> 
> Is it possible that this loop can get stuck with a corrupt filesystem image?

yup.  ext2 did that a couple of times.  See the explicit check for
de->rec_len == 0 in ext2_find_entry().

We fixed one filesystem and forgot the others.  Again.
