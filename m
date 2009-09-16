Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZIPJCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZIPJCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757707AbZIPJCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:02:18 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:57996 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbZIPJCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K05KJSFQ2M2ELg0lf8jPcGLU3BpD0aUNJnDzJuJoYEIZAsR41AH9hMnSnAqb1tlU6N
         OwOcbPIOVyvCAcknSA45ZkrvENpJKYWOXefXP3RvugoI4ZXW1oj3v+A1ESjIxiRiTOI3
         XclRdP/56hMjcna6T+ytdJg4t2c7v5ireTGGI=
MIME-Version: 1.0
In-Reply-To: <7d8fb81e0909160101m4244b24bq1cc0f650bcc9dca1@mail.gmail.com>
References: <7d8fb81e0909160101m4244b24bq1cc0f650bcc9dca1@mail.gmail.com>
Date: Wed, 16 Sep 2009 17:02:20 +0800
Message-ID: <2375c9f90909160202p59fe30a2neb20b7000cf270cb@mail.gmail.com>
Subject: Re: BUG: kernel oops in 2.6.23.14 - unable to handle kernel paging 
	request
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Vinubalaji Gopal <vinubalaji@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 4:01 PM, Vinubalaji Gopal <vinubalaji@gmail.com> wrote:
> Hi all,
>
> I got the following kernel oops message on kernel version 2.6.23. Have
> been searching the list archives, bug database and googling different
> terms related to this oops message, but can't find anything. Any idea
> on what could be causing this - a hardware failure or a bug in the
> kernel? This is happening very rarely and is hard to reproduce :(.
> This kernel is a patched kernel with ipsets and bootsplash.


Does the original kernel have the same problem? If yes, could
you please try 2.6.31?

>
> Thanks in advance.
>
> BUG: unable to handle kernel paging request at virtual address 000c0000
>  printing eip:
> c01723b0
> *pde = 00000000
> Oops: 0000 [#347]
> SMP
> Modules linked in:
> CPU:    0
> EIP:    0060:[<c01723b0>]       Tainted: G      B D VLI
> EIFLAGS: 000010206   (2.6.23)
> EIP is at __kill_fasync+0x10/0x60
> eax: 000c0000   ebx: 000c0000   ecx: 00020001   edx: 0000001d
> esi: 0000001d   edi: 00020001   ebp: 0000000c   esp: d36ebdd4
> ds: 007b   es: 007b   fs: 00d8   gs: 033   ss: 0068
> Process bounce (pid: 29145, ti=d36ea000 task=c2f37aa0 task.ti=d36ea000)
> Stack: 00000000 d5e0c740 000c0000 ccc7792c c0674045 000c0000 d5e11580 c067730f
>       00000000 ccc77900 d3a58600 c072b22a d36ebe1c 00000000 d5e11580 d5e113c0
>       d36ebe78 d36ebe98 00000000 000071d9 00000194 00000194 00000000 00000000
> Call Trace:
>  [<c0674045>] sock_value_async+0x55/0x80
>  [<c067730f>] sock_def_readable+0x5f/0x80
>  [<c072b22a>] unix_stream_sendmsg+0x1ea/0x320
>  [<c0673b3d>] do_sock_write+0x9d/0xb0
>  [<c-673ba4>] sock_aio_write+0x54/0x70
>  [<c01477d5>] find_lock_page+0x25/0x90
>  [<c0166660>] do_sync_write+0xc0/0x100
>  [<c0133700>] autoremove_wake_function+0x0/0x50
>  [<c0114d29>] do_page_fault+0x1b/0x630
>  [<c01667d9>] vfs_write+0x139/0x150
>  [<c01668b7>] sys_write+047/080
>  [<c0102b3e>] syscall_call+0x7/0xb
>  =======================
> Code: 04 a1 04 fe a5 c0 89 fa e0 be 12 ff ff eb bf b6 00 00 00 00 8d
> bf 00 00 00 00 57 89 cf 56 09 d6 53 03 ec 04 05 c0 74 24 <81> 3b 01 46
> 00 00 75 31 0b 43 0c 83 c0 28 83 fe 17 74 1d 8b 53
> EIP: [<c01723b0>] __kill_fasync+0x10/0x60 SS:ESP 0068:d36ebdd4

Interesting call trace...

It says you are writing to a Unix datagram socket, seems this happens
in softirq context? Mind to try script/markup_oops.pl?

If you have a debug kernel, what does `addr2line -e vmlinux 0xc01723b0`
say?

Thanks.
