Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbZKRCKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbZKRCKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 21:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZKRCKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 21:10:15 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:56785 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZKRCKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 21:10:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x+YMdN+cEqCi4MdShv5OpgaTeUyhsHjPGV1oSt1G2PY7LBLEOzuQTxDmRGFSF2kzYE
         qEUoAQNHu8ngQ4D5r0Jej4/0sOyFLUgYKKCayKjL2/sLDNT1YNwgGUQyvFSSoA7qA8le
         6NUxml701OctUo2NoUQF7c5G7MT0mfZ1qyNCY=
MIME-Version: 1.0
In-Reply-To: <2375c9f90909160202p59fe30a2neb20b7000cf270cb@mail.gmail.com>
References: <7d8fb81e0909160101m4244b24bq1cc0f650bcc9dca1@mail.gmail.com>
	 <2375c9f90909160202p59fe30a2neb20b7000cf270cb@mail.gmail.com>
Date: Tue, 17 Nov 2009 18:10:19 -0800
Message-ID: <7d8fb81e0911171810i6f5f127as4cef44dbc728b252@mail.gmail.com>
Subject: Re: BUG: kernel oops in 2.6.23.14 - unable to handle kernel paging 
	request
From: Vinubalaji Gopal <vinubalaji@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Americo,

Sorry for the late reply - i deployed a new 2.6.23 kernel without any
patches and was waiting for the crash to happen since this crash
doesn't happen everywhere and only at one or two customer places at
random times. It was running well for a while and suddenly the crash
did happen.
See my other answers inline:

On Wed, Sep 16, 2009 at 1:02 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Sep 16, 2009 at 4:01 PM, Vinubalaji Gopal <vinubalaji@gmail.com> wrote:
>> Hi all,
>>
>> I got the following kernel oops message on kernel version 2.6.23. Have
>> been searching the list archives, bug database and googling different
>> terms related to this oops message, but can't find anything. Any idea
>> on what could be causing this - a hardware failure or a bug in the
>> kernel? This is happening very rarely and is hard to reproduce :(.
>> This kernel is a patched kernel with ipsets and bootsplash.
>
>
> Does the original kernel have the same problem? If yes, could
> you please try 2.6.31?
>

Yes the original kernel without any patches does have the problem. I
couldn't try the latest kernel yet, but can do if i know that would
really solve the problem.

>>
>> Thanks in advance.
>>
>> BUG: unable to handle kernel paging request at virtual address 000c0000
>>  printing eip:
>> c01723b0
>> *pde = 00000000
>> Oops: 0000 [#347]
>> SMP
>> Modules linked in:
>> CPU:    0
>> EIP:    0060:[<c01723b0>]       Tainted: G      B D VLI
>> EIFLAGS: 000010206   (2.6.23)
>> EIP is at __kill_fasync+0x10/0x60
>> eax: 000c0000   ebx: 000c0000   ecx: 00020001   edx: 0000001d
>> esi: 0000001d   edi: 00020001   ebp: 0000000c   esp: d36ebdd4
>> ds: 007b   es: 007b   fs: 00d8   gs: 033   ss: 0068
>> Process bounce (pid: 29145, ti=d36ea000 task=c2f37aa0 task.ti=d36ea000)
>> Stack: 00000000 d5e0c740 000c0000 ccc7792c c0674045 000c0000 d5e11580 c067730f
>>       00000000 ccc77900 d3a58600 c072b22a d36ebe1c 00000000 d5e11580 d5e113c0
>>       d36ebe78 d36ebe98 00000000 000071d9 00000194 00000194 00000000 00000000
>> Call Trace:
>>  [<c0674045>] sock_value_async+0x55/0x80
>>  [<c067730f>] sock_def_readable+0x5f/0x80
>>  [<c072b22a>] unix_stream_sendmsg+0x1ea/0x320
>>  [<c0673b3d>] do_sock_write+0x9d/0xb0
>>  [<c-673ba4>] sock_aio_write+0x54/0x70
>>  [<c01477d5>] find_lock_page+0x25/0x90
>>  [<c0166660>] do_sync_write+0xc0/0x100
>>  [<c0133700>] autoremove_wake_function+0x0/0x50
>>  [<c0114d29>] do_page_fault+0x1b/0x630
>>  [<c01667d9>] vfs_write+0x139/0x150
>>  [<c01668b7>] sys_write+047/080
>>  [<c0102b3e>] syscall_call+0x7/0xb
>>  =======================
>> Code: 04 a1 04 fe a5 c0 89 fa e0 be 12 ff ff eb bf b6 00 00 00 00 8d
>> bf 00 00 00 00 57 89 cf 56 09 d6 53 03 ec 04 05 c0 74 24 <81> 3b 01 46
>> 00 00 75 31 0b 43 0c 83 c0 28 83 fe 17 74 1d 8b 53
>> EIP: [<c01723b0>] __kill_fasync+0x10/0x60 SS:ESP 0068:d36ebdd4
>



> It says you are writing to a Unix datagram socket, seems this happens
> in softirq context? Mind to try script/markup_oops.pl?
>
I couldn't run this script. Is it obsolete now?


> If you have a debug kernel, what does `addr2line -e vmlinux 0xc01723b0`
> say?

I don't have the vmlinux. Can i build a kernel with the same config
and have a debug kernel and run the above command or is it too late
and i should be running a new kernel with vmlinux so that i could run
the above command (I use debian to build the kernel and building
vmlinux is a special configuration in debian)?

-- 
Vinu

In a world without fences who needs Gates?
