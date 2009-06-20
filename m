Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbZFTONl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbZFTONl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 10:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZFTONc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 10:13:32 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:36136 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbZFTONb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 10:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X6jqJQg/JNkZB5uF5DhrkjHyhoBFjsrNDbrVQn0XzURhUpvqwLZlaQGUH2x3HL2Pn7
         1zR/GOt1742V2H1gZYGYuxID/MbHqnb0POGWs0qkpq5xN3y0Bb15fBzSfDX7Ob/8h4bi
         3e/9+7AxBooAyZKtcBOvMO2X8Cpq7iGyYWFtc=
Subject: BUG] Strange oopses in 2.6.30
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1245448091.5475.19.camel@localhost>
References: <1245448091.5475.19.camel@localhost>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 17:08:28 +0300
Message-Id: <1245506908.6327.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-20 at 00:48 +0300, Maxim Levitsky wrote:
> I see lots of following oopses in 2.6.30 and latest -git 
> 
> Many different applications shows up, not just reiserfsck
> Something in MM I guess, it makes me worry. But system seems to work.
> 
> Is this known?
> 
> dmesg attached.
> 
> 
> [   34.544040] BUG: Bad page state in process reiserfsck  pfn:37d86
> [   34.544044] page:c2a34f38 flags:3650000c count:0 mapcount:0
> mapping:(null) index:bffeb
> [   34.544048] Pid: 2654, comm: reiserfsck Tainted: G    B
> 2.6.30-git #4
> [   34.544051] Call Trace:
> [   34.544055]  [<c04cd26a>] ? printk+0x18/0x1e
> [   34.544059]  [<c018f065>] bad_page+0xd5/0x140
> [   34.544064]  [<c0190097>] free_hot_cold_page+0x1e7/0x280
> [   34.544069]  [<c0193682>] ? release_pages+0x92/0x1b0
> [   34.544074]  [<c0190155>] __pagevec_free+0x25/0x30
> [   34.544078]  [<c0193758>] release_pages+0x168/0x1b0
> [   34.544084]  [<c0193cf3>] ? lru_add_drain+0x53/0xd0
> [   34.544088]  [<c01ab7d4>] free_pages_and_swap_cache+0x84/0xa0
> [   34.544093]  [<c019ff5d>] unmap_vmas+0x73d/0x760
> [   34.544099]  [<c016480e>] ? lock_release_non_nested+0x15e/0x270
> [   34.544104]  [<c01a43b5>] exit_mmap+0xb5/0x1b0
> [   34.544109]  [<c0138666>] mmput+0x36/0xc0
> [   34.544113]  [<c013c874>] exit_mm+0xe4/0x120
> [   34.544117]  [<c0175539>] ? acct_collect+0x139/0x180
> [   34.544122]  [<c013e889>] do_exit+0x6b9/0x720
> [   34.544142]  [<c01bcac2>] ? vfs_write+0x122/0x180
> [   34.544146]  [<c01bbda0>] ? do_sync_write+0x0/0x110
> [   34.544151]  [<c013e920>] do_group_exit+0x30/0x90
> [   34.544156]  [<c013e993>] sys_exit_group+0x13/0x20
> [   34.544161]  [<c01039e8>] sysenter_do_call+0x12/0x3c
> [   34.544180] BUG: Bad page state in process reiserfsck  pfn:37d91
> [   34.544184] page:c2a35174 flags:3650000c count:0 mapcount:0
> mapping:(null) index:bfff6
> [   34.544188] Pid: 2654, comm: reiserfsck Tainted: G    B
> 2.6.30-git #4
> 

This really worries me

