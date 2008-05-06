Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbYEFBGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbYEFBGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 21:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbYEFBGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 21:06:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:27980 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbYEFBGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 21:06:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pNzGZChtYA2B1pxJXcGydP/dbeo9sg4hIj8VoVjr81oyhjXjf28tEdaOIgdDIjmxucfg17ZtEkrCqD2i2LyJEVs6JAs2naZ5d7pbxxJvHs06B8L3s6JO5wlmNc9LlrDyqYrgf/CniEQb9vyh+1/bM1r/f5oOoogTNJEy/uyWmm4=
Message-ID: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com>
Date: Tue, 6 May 2008 09:06:40 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.26-rc1 - pgtable_32.c:178 pmd_bad
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 3:38 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  So this merge window was somewhat rocky in the sense that there was a lot
>  of arguments about it, but at the same time I at least personally think
>  that from a technical angle, we had somewhat less scary stuff going on
>  than has been almost the rule lately.

I'm seeing this on a Dell 2950 (quad-core) during boot up, but not on
my IBM X60s (dual-core). This is using the lastest git 2.6.26-rc1.

Just checking to see if this is a known bug before doing the bisect --
more painful on the 2950 to reboot.

Thanks,
Jeff.


Freeing unused kernel memory: 252k freed
------------[ cut here ]------------
WARNING: at arch/x86/mm/pgtable_32.c:178 pmd_bad+0xa3/0xe3()
Modules linked in:
Pid: 1226, comm: khelper Not tainted 2.6.26-rc1 #4
 [<c0121614>] warn_on_slowpath+0x40/0x65
 [<c011823e>] kmap_atomic+0x11/0x14
 [<c01183b7>] kunmap_atomic+0x4f/0x78
 [<c014a0db>] get_page_from_freelist+0x33a/0x3da
 [<c014a225>] __alloc_pages_internal+0x98/0x356
 [<c01181f8>] kmap_atomic_prot+0x102/0x137
 [<c01183b7>] kunmap_atomic+0x4f/0x78
 [<c0154dd0>] handle_mm_fault+0xb70/0xbba
 [<c011770c>] pmd_bad+0xa3/0xe3
 [<c0151cad>] follow_page+0x109/0x30a
 [<c015516b>] get_user_pages+0x351/0x3c0
 [<c016aec4>] get_arg_page+0x2b/0x7b
 [<c016afe1>] copy_strings+0xcd/0x173
 [<c016b0a0>] copy_strings_kernel+0x19/0x27
 [<c016c28a>] do_execve+0xd9/0x18f
 [<c010136a>] sys_execve+0x2a/0x4f
 [<c0102d22>] syscall_call+0x7/0xb
 [<c038007b>] i8042_probe+0x29f/0x508
 [<c0106034>] kernel_execve+0x14/0x18
 [<c012dcfc>] ____call_usermodehelper+0x0/0x105
 [<c012ddf7>] ____call_usermodehelper+0xfb/0x105
 [<c012dcfc>] ____call_usermodehelper+0x0/0x105
 [<c0103917>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 6aae36751415b63a ]---
Adding 27350652k swap on /dev/sda3.  Priority:-1 extents:1 across:27350652k
