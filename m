Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbYGRRFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbYGRRFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbYGRRFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:05:35 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:3367 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307AbYGRRFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VJq8g65VAj0HzwksGq5rbmYHgCBLyvjJn2jwGrlO/NGYiDwbutNscwLkj8WZg5/neS
         MlZ4dU6UCfAWBxsz0smFnooMgRacLfANgE5wNKTmjhLHkNtMnGTyNgx9gQG+Mz7RDW8o
         EYo8sLfedtnNrGgQzebaSE+VcJ6HUsipuo9To=
Message-ID: <19f34abd0807181005m19f1770bka9d8bbac7a500d1@mail.gmail.com>
Date: Fri, 18 Jul 2008 19:05:31 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: latest -git: A peculiar case of a stuck process (ext3/sched-related?)
Cc: linux-ext4@vger.kernel.org, sct@redhat.com, akpm@linux-foundation.org,
       adilger@sun.com, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <e9e943910807180600t1e65a9b8o7f85e2751368275d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807180245l2a633644n1a8d91cb3587d9e4@mail.gmail.com>
	 <19f34abd0807180317g40a218a2p2bb2857c6f5aa659@mail.gmail.com>
	 <e9e943910807180600t1e65a9b8o7f85e2751368275d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 3:00 PM, Duane Griffin <duaneg@dghda.com> wrote:
> 2008/7/18 Vegard Nossum <vegard.nossum@gmail.com>:
>> And the ext3_find_entry() corresponds to this line:
>>
>>        for (; de < top; de = ext3_next_entry(de)) /* <--- HERE! */
>>        if (ext3_match (namelen, name, de)) {
>>                if (!ext3_check_dir_entry("ext3_find_entry",
>>                                          dir, de, bh,
>>                          (block<<EXT3_BLOCK_SIZE_BITS(sb))
>>                                  +((char *)de - bh->b_data))) {
>>                        brelse (bh);
>>                        *err = ERR_BAD_DX_DIR;
>>                        goto errout;
>>                }
>>                *res_dir = de;
>>                dx_release (frames);
>>                return bh;
>>        }
>>
>> Is it possible that this loop can get stuck with a corrupt filesystem image?
>
> It certainly is. This is the same problem as the first case reported
> at http://bugzilla.kernel.org/show_bug.cgi?id=10882. There is a patch
> in -mm for it already (2fde9f7a0faabe821b31ccd982d482c21f7c503f),
> posted here: http://marc.info/?l=linux-kernel&m=121486328013470.
>
> Hopefully that should fix the problem for you.

Oh, right. Thanks!

(This patch looks much shorter than the one I found for ext2, though,
i.e. commit aa4f3f285643956bb614cf7b8f88e15f3a375886 from the
historical git repository. Does it fix all the right cases? I don't
mean to troll -- I just wanted to be sure you knew about it.)

I'll try it and report back if there's any trouble. Thanks,

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
