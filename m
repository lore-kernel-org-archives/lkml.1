Return-Path: <linux-kernel-owner+w=401wt.eu-S1761024AbYEFMuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024AbYEFMuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbYEFMuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:50:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbYEFMuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:50:03 -0400
Date: Tue, 6 May 2008 14:49:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux 2.6.26-rc1 - pgtable_32.c:178 pmd_bad
Message-ID: <20080506124946.GA2146@elte.hu>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> On Sun, May 4, 2008 at 3:38 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >  So this merge window was somewhat rocky in the sense that there was a lot
> >  of arguments about it, but at the same time I at least personally think
> >  that from a technical angle, we had somewhat less scary stuff going on
> >  than has been almost the rule lately.
> 
> I'm seeing this on a Dell 2950 (quad-core) during boot up, but not on
> my IBM X60s (dual-core). This is using the lastest git 2.6.26-rc1.
> 
> Just checking to see if this is a known bug before doing the bisect -- 
> more painful on the 2950 to reboot.

> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/pgtable_32.c:178 pmd_bad+0xa3/0xe3()
> Modules linked in:
> Pid: 1226, comm: khelper Not tainted 2.6.26-rc1 #4
>  [<c0121614>] warn_on_slowpath+0x40/0x65
>  [<c011823e>] kmap_atomic+0x11/0x14
>  [<c01183b7>] kunmap_atomic+0x4f/0x78
>  [<c014a0db>] get_page_from_freelist+0x33a/0x3da
>  [<c014a225>] __alloc_pages_internal+0x98/0x356
>  [<c01181f8>] kmap_atomic_prot+0x102/0x137
>  [<c01183b7>] kunmap_atomic+0x4f/0x78
>  [<c0154dd0>] handle_mm_fault+0xb70/0xbba
>  [<c011770c>] pmd_bad+0xa3/0xe3
>  [<c0151cad>] follow_page+0x109/0x30a
>  [<c015516b>] get_user_pages+0x351/0x3c0
>  [<c016aec4>] get_arg_page+0x2b/0x7b
>  [<c016afe1>] copy_strings+0xcd/0x173
>  [<c016b0a0>] copy_strings_kernel+0x19/0x27
>  [<c016c28a>] do_execve+0xd9/0x18f
>  [<c010136a>] sys_execve+0x2a/0x4f
>  [<c0102d22>] syscall_call+0x7/0xb
>  [<c038007b>] i8042_probe+0x29f/0x508
>  [<c0106034>] kernel_execve+0x14/0x18
>  [<c012dcfc>] ____call_usermodehelper+0x0/0x105
>  [<c012ddf7>] ____call_usermodehelper+0xfb/0x105
>  [<c012dcfc>] ____call_usermodehelper+0x0/0x105
>  [<c0103917>] kernel_thread_helper+0x7/0x10

no, i have not seen this reported yet.

we have an strace/ptrace fix pending in x86.git - but that should not 
affect khelper.

	Ingo
