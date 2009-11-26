Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZKZFwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZKZFwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 00:52:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZKZFwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 00:52:08 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:33082 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZKZFwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 00:52:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZzjEqRn2lOpWXL8eRB/ZzjnUdp1dWX3mx8egqs1HbvujYeIwEaK7WhxVwub+zkqovU
         CPLnLbXs0rOW5o8Abi0XBrT0pzrAnRkDY+K5rTC/ZY/swo95AlVVjjpz55fIvskCoLJI
         RjlovDlnSqbNW7+Y6n6pVJ4FITGULeIBwlvo8=
MIME-Version: 1.0
In-Reply-To: <3877989d0911251943j6860e88ci93e237ba65835bc7@mail.gmail.com>
References: <3877989d0911251943j6860e88ci93e237ba65835bc7@mail.gmail.com>
Date: Thu, 26 Nov 2009 13:52:13 +0800
Message-ID: <3877989d0911252152g6bd13a32oc387e282eceda3f1@mail.gmail.com>
Subject: Re: ia64 lockdep: trying to register non-static key (mm->mmap_sem)
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for noise, I've figured it out that locdep annoatation is missed in IA64
__rwsem_initializer.

On Thu, Nov 26, 2009 at 11:43 AM, Luming Yu <luming.yu@gmail.com> wrote:
> Anybody know how I should do to fix the lockdep
> warning below, which is triggered in
> ia64_brk doing "down_write(&mm->mmap_sem)"
>
> Any comments are appreciated.
>
>
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
>
> Call Trace:
>  [<a000000100017330>] show_stack+0x70/0xc0
>                                sp=e0000004807a7c50 bsp=e0000004807a1c78
>  [<a0000001000173d0>] dump_stack+0x50/0x80
>                                sp=e0000004807a7e20 bsp=e0000004807a1c58
>  [<a0000001000f7ca0>] __lock_acquire+0x1a0/0x13e0
>                                sp=e0000004807a7e20 bsp=e0000004807a1bc0
>  [<a0000001000fc310>] lock_acquire+0x170/0x1e0
>                                sp=e0000004807a7e20 bsp=e0000004807a1b60
>  [<a0000001008338d0>] down_write+0x70/0x180
>                                sp=e0000004807a7e20 bsp=e0000004807a1b28
>  [<a00000010003b960>] ia64_brk+0x60/0x280
>                                sp=e0000004807a7e20 bsp=e0000004807a1aa0
>  [<a00000010000c620>] ia64_ret_from_syscall+0x0/0x20
>
>
> Thanks,
> Luming
>
