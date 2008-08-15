Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbYHOP1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbYHOP1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYHOP1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:27:23 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:61561 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYHOP1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bdbbgj99RpNVwXi+RG6ztHMeCJjBRj3Q6Mm6xIp7jU4c13aV5Zo9+DwovkRrFTIneb
         qjc+AUptFimAGfDIqztc2kU+1Q0juwzd+Y6KXDV2QIWNiwPa9zgtLV97VFXx1bQcJl11
         /YT8RvAYEkMLZtCsaD3ImO5ZhxFSdi5tsH/ZI=
Message-ID: <19f34abd0808150827m5128c8f6wd517796d95227654@mail.gmail.com>
Date: Fri, 15 Aug 2008 17:27:20 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.25.11-97.fc9 (P): idr_remove called for id=236 which is not allocated
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808150811w2b77479fnead3ae6b527ad4dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808150811w2b77479fnead3ae6b527ad4dc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 5:11 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> First the confessions: It's fedora-patched kernel, 2.6.25.11-97.fc9,
> tainted by NVIDIA driver. So feel free to drop to /dev/null until I
> can reproduce on a clean and recent kernel. (But -rc3 didn't boot for
> me, and I don't have anything else handy atm.)

I did get -rc3 working with some command line options.

>
> By bashing on random device nodes (with mknod + mmap as root), I got a
> few messages of this kind:
>
> idr_remove called for id=236 which is not allocated.
> Pid: 3019, comm: a.out Tainted: P         2.6.25.11-97.fc9.i686 #1
>  [<c04f030c>] idr_remove+0xd5/0x138
>  [<c0540bfc>] release_dev+0x5bd/0x5cf
>  [<c04909fd>] ? d_free+0x3b/0x4d
>  [<c04955d0>] ? mntput_no_expire+0x16/0x69
>  [<c048309d>] ? __fput+0x149/0x151
>  [<c0540d8c>] tty_release+0x12/0x1c
>  [<c0483001>] __fput+0xad/0x151
>  [<c04830bc>] fput+0x17/0x19
>  [<c04807df>] filp_close+0x50/0x5a
>  [<c0480852>] sys_close+0x69/0xa1
>  [<c0405bf2>] syscall_call+0x7/0xb
>  [<c0620000>] ? agp_amd64_probe+0x134/0x3ee
>  =======================

Now it looks more like this (with very frequent messages):

ida_remove called for id=112 which is not allocated.
ida_remove called for id=67 which is not allocated.
ida_remove called for id=191 which is not allocated.
ida_remove called for id=23 which is not allocated.

..and with no backtrace, so I guess it means "not harmful". Sorry for the noise.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
