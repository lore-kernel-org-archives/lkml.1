Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbXFQHzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbXFQHzV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 03:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbXFQHzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 03:55:10 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:11203 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbXFQHzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 03:55:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bS/IqUw2Dg7KMCuvTRFdw39mAvU+oFW8MnvCbggTGY2wmoibsrMoPnevriqap5y3F8EI8/s+76NOHb71BoqXjgfdMMpHfvAj6eQv0AZXDHH6AReZU9DadWxUosDEDztG3MzJzbsSjmUOjP/wfkyea3HNNcNhN53KLUFVXg4cEWg=
Message-ID: <745af2c30706170055g1e0df27ek7e90b3338825bd42@mail.gmail.com>
Date: Sun, 17 Jun 2007 08:55:07 +0100
From: "Tom Robinson" <thomas.robinson@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: kernel BUG at mm/swap_state.c:78! (v2.6.21 under vmware)
In-Reply-To: <745af2c30706140842w5eabdf1bjdcc5fd7c2a92b77e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <745af2c30706140842w5eabdf1bjdcc5fd7c2a92b77e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, just to add to the original email - the system has been stable
since I rebooted a couple of days ago, until this morning when I got
the following:

Jun 17 08:47:41 acid kernel: BUG: unable to handle kernel paging
request at virtual address 0000f1e8
Jun 17 08:47:41 acid kernel:  printing eip:
Jun 17 08:47:41 acid kernel: *pde = 00000000
Jun 17 08:47:41 acid kernel: Oops: 0000 [#1]
Jun 17 08:47:41 acid kernel: SMP
Jun 17 08:47:41 acid kernel: CPU:    0
Jun 17 08:47:41 acid kernel: EIP:    0073:[<0808a542>]    Not tainted VLI
Jun 17 08:47:41 acid kernel: EFLAGS: 00010282   (2.6.21 #2)
Jun 17 08:47:41 acid kernel: EIP is at 0x808a542
Jun 17 08:47:42 acid kernel: eax: 0814e008   ebx: 081cf060   ecx:
00000000   edx: 0814e008
Jun 17 08:47:42 acid kernel: esi: 00000000   edi: 081e3ef8   ebp:
bfd6a9d8   esp: bfd6a9ac
Jun 17 08:47:42 acid kernel: ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 007b
Jun 17 08:47:42 acid kernel: Process get_listings.pl (pid: 10746,
ti=c7e16000 task=c708c5d0 task.ti=c7e16000)
Jun 17 08:47:42 acid kernel: EIP: [<0808a542>] 0x808a542 SS:ESP 007b:bfd6a9ac

Seems to still be up and running at the moment.

Cheers,

Tom

On 6/14/07, Tom Robinson <thomas.robinson@gmail.com> wrote:
> Hi,
>
> Experienced this strange crash this morning and was wondering if
> anyone could tell me what it might be.  The system in question was
> running under vmware but with a physical hard disk.  Originally I
> thought it might be a memory problem so I ran memtest86+ and checked
> the swap with mkswap -c but neither reported any problems.
>
> The kernel is a clean compile of version 2.6.21 with no modules loaded.
>
> /proc/version shows:
> Linux version 2.6.21 (root@acid) (gcc version 4.1.2 20061115
> (prerelease) (Debian 4.1.1-21)) #2 SMP Wed Jun 13 10:36:40 BST 2007
>
> Outputs from other /proc/xxx as given in the bug reporting guidelines
> are at the bottom of the email.
>
> Full text of the logfile is below.  It also includes all the messages
> spat out by the kernel when I rebooted it afterwards, incase that will
> help diagnose the problem.
>
> Cheers,
>
> Tom
>
> Jun 14 06:26:51 acid kernel: ------------[ cut here ]------------
> Jun 14 06:26:51 acid kernel: kernel BUG at mm/swap_state.c:78!
> Jun 14 06:26:51 acid kernel: invalid opcode: 0000 [#2]
> Jun 14 06:26:51 acid kernel: SMP
> Jun 14 06:26:51 acid kernel: Modules linked in:
> Jun 14 06:26:51 acid kernel: CPU:    0
> Jun 14 06:26:51 acid kernel: EIP:    0060:[<c0148123>]    Not tainted VLI
> Jun 14 06:26:51 acid kernel: EFLAGS: 00010202   (2.6.21 #2)
> Jun 14 06:26:51 acid kernel: EIP is at __add_to_swap_cache+0x1e/0x8e
> Jun 14 06:26:51 acid kernel: eax: 40000849   ebx: c1181400   ecx:
> 00010220   edx: 00000002
> Jun 14 06:26:51 acid kernel: esi: 00000002   edi: 00000002   ebp:
> c0517700   esp: d1a83e10
> Jun 14 06:26:51 acid kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Jun 14 06:26:51 acid kernel: Process kswapd0 (pid: 157, ti=d1a82000
> task=c12fba50 task.ti=d1a82000)
> Jun 14 06:26:51 acid kernel: Stack: c1181400 00000002 00000020
> c0148497 c1181400 c9381208 00000001 c013e107
> Jun 14 06:26:51 acid kernel:        d1a83f14 c0568b30 d1a83f7c
> 00000020 00000000 00000000 00000020 00000004
> Jun 14 06:26:51 acid kernel:        00000001 00000000 00000020
> 00000004 00000001 c119c800 c10daaa0 c10d1740
> Jun 14 06:26:51 acid kernel: Call Trace:
> Jun 14 06:26:51 acid kernel:  [<c0148497>] add_to_swap+0x2d/0x66
> Jun 14 06:26:51 acid kernel:  [<c013e107>] shrink_inactive_list+0x1e9/0x742
> Jun 14 06:26:51 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
> Jun 14 06:26:51 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
> Jun 14 06:26:51 acid kernel:  [<c013ebcb>] kswapd+0x2a4/0x3cf
> Jun 14 06:26:51 acid kernel:  [<c01296ed>] autoremove_wake_function+0x0/0x35
> Jun 14 06:26:51 acid kernel:  [<c013e927>] kswapd+0x0/0x3cf
> Jun 14 06:26:51 acid kernel:  [<c0129624>] kthread+0xb0/0xd8
> Jun 14 06:26:51 acid kernel:  [<c0129574>] kthread+0x0/0xd8
> Jun 14 06:26:51 acid kernel:  [<c0103cab>] kernel_thread_helper+0x7/0x10
> Jun 14 06:26:51 acid kernel:  =======================
> Jun 14 06:26:51 acid kernel: Code: ff 05 18 a0 61 c0 89 15 14 a0 61 c0
> c3 57 89 d7 56 53 89 c3 8b 00 25 00 80 00 00 66 85 c0 74 04 0f 0b eb
> fe 8b 03 f6 c4 08 74 04 <0f> 0b eb fe 89 c8 e8 06 f3 0b 00 85 c0 89 c6
> 75 59 b8 b0 9d 51

<snip>

-- 
Tom Robinson
tom.robinson@dunelm.org.uk
