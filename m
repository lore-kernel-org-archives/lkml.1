Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYHVQvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYHVQvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYHVQvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:51:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:61012 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbYHVQvC (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=G2k3uSNS7QnF4kL/wbIS5xhx79DOr1sg1JTjC7ThW1D9Y0FtRk+QlabSN9Ue1rGR+V
         PBHLgFuc+iHR0r8kCKeQw9tFtYNtdnx7J0T+UH21Glix84M9kH9oOsDceaKOhDfODfOy
         8qfARH0YFJsJFtYwh+zg8WQfQRKAw007yNjjA=
Message-ID: <6934efce0808220951i5a2cd6f9t70f9c522eae6f1d6@mail.gmail.com>
Date: Fri, 22 Aug 2008 09:51:01 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com>
	 <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The version in SVN seems to be slightly older than the one you submitted?

Oops.  Okay I must have neglected to sync at the very end.  Thanks.

I forgot, there is also a git repo at

git://git.infradead.org/users/jehulber/axfs.git

> Which platform(s) do you use for testing?

ARM, x86

> I gave AxFS a try on PS3 (ppc64, always use big-endian 64-bit for testing new
> code ;-).

Smart.  Hmmm, If only I had a PS3....

> When mounting the image, I got the crash below:
>
> | attempt to access beyond end of device
> | loop0: rw=0, want=4920, limit=4912
> | [c00000000c1e34c0] [d000000000037974] .axfs_copy_block+0x8c/0x144 [axfs] (unreliable)
> | [c00000000c1e3580] [d000000000035f20] .axfs_copy_metadata+0x154/0x1cc [axfs]
> | [c00000000c1e3630] [d000000000035fd8] .axfs_verify_eofs_magic+0x40/0xa0 [axfs]
> | [c00000000c1e36c0] [d000000000036678] .axfs_fill_super+0x3c0/0x7c8 [axfs]
> | [c00000000c1e3780] [c0000000000d1670] .get_sb_bdev+0x154/0x1ec
> | [c00000000c1e3860] [d000000000037a94] .axfs_get_sb_bdev+0x34/0x6c [axfs]
> | [c00000000c1e38f0] [d000000000035d0c] .axfs_get_sb+0x320/0x394 [axfs]
> | [c00000000c1e3a00] [c0000000000d1318] .vfs_kern_mount+0x88/0x108
> | [c00000000c1e3ab0] [c0000000000d143c] .do_kern_mount+0x68/0x148
> | [c00000000c1e3b60] [c0000000000f0a10] .do_new_mount+0x90/0xf4
> | [c00000000c1e3c10] [c0000000000f0c5c] .do_mount+0x1e8/0x23c
> | [c00000000c1e3d60] [c000000000114778] .compat_sys_mount+0x21c/0x2ac
> | [c00000000c1e3e30] [c0000000000074dc] syscall_exit+0x0/0x40

Yeah we've had this problem before.  I'm not so sure this is an endian
bug, though it is likely.

> When mounting (also on PS3) an image created on ia32, I get a different crash:
>
> | axfs: wrong magic
>
> So I guess some parts are not yet 64-bit or endian clean.

Can you run mkfs.axfs on the same trivial directory on both ia32 and
PPC64 and then get me the resulting images?
