Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbXFKRL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbXFKRL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 13:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbXFKRLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 13:11:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:20591 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbXFKRLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 13:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XlBvrAl8U3gQo69QC4D39LAlPgngzdW6Qsc9L1W0GYEygXk9UauTXB7muyqxNrAz3uzMuKGDZQzh5QApX6xvkxT4ULa/eFoNDwiNhBYTYj8mRF8oijerQgEiK7g6n5GCNOrggahkKX2pvGNDZsV0Ox5YM+uV7/vO15CxZIEjLa4=
Message-ID: <1defaf580706111011w641b26fbu68d6d34028f6e953@mail.gmail.com>
Date: Mon, 11 Jun 2007 19:11:16 +0200
From: "=?ISO-8859-1?Q?H=E5vard_Skinnemoen?=" <hskinnemoen@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: kernel BUG at mm/slub.c:3689!
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
	 <Pine.LNX.4.64.0706110918340.15466@schroedinger.engr.sgi.com>
	 <1defaf580706110943q56d83939t9ab6331cc45b4810@mail.gmail.com>
	 <Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Christoph Lameter <clameter@sgi.com> wrote:
> Ahhh... I see its the same phenomenon as before but triggered by
> a different cause.
>
> If you set the align to 32 then the first kmalloc slabs of size
>
> 8
> 16
> 32
>
> are all of the same size which leads to duplicate files in sysfs.

Yes, that seems to be the problem.

> Does this patch fix it?

Unfortunately, no. But I get a different error message; see below...

Also unfortunately, I won't be able to do any more testing until I get
back to work tomorrow -- I'm currently at home and I can't reset my
board remotely (Doh! Why didn't I set panic_timeout...)

Haavard

kobject_add failed for :0000016 with -EEXIST, don't try to register
things with the same name in the same directory.
Call trace:
 [<9000f14e>] dump_stack+0x1a/0x24
 [<90093128>] kobject_shadow_add+0xc4/0xe8
 [<90093154>] kobject_add+0x8/0xc
 [<9003dec4>] sysfs_slab_add+0xb0/0xf0
 [<900046c6>] slab_sysfs_init+0x26/0x78
 [<900003f0>] kernel_init+0x74/0x1c0
 [<90015cd4>] do_exit+0x0/0x52c

------------[ cut here ]------------
kernel BUG at /home/hskinnemoen/git/linux/mm/slub.c:3686!
Oops: Kernel BUG, sig: 9 [#1]
FRAME_POINTER chip: 0x01f:0x1e82 rev 0
Modules linked in:
PC is at slab_sysfs_init+0x28/0x78
LR is at 0x9014e654
pc : [<900046c8>]    lr : [<9014e654>]    Not tainted
sp : 901cbf98  r12: ffffffef  r11: 00000001
r10: 00000001  r9 : 00000000  r8 : 9014e654
r7 : 901cbf98  r6 : 9014a2b4  r5 : 00000000  r4 : 00000000
r3 : 00000000  r2 : 90015cd4  r1 : 9000b4d0  r0 : 00000000
Flags: qvNzc
Mode bits: hrje....g
CPU Mode: Supervisor
Process: swapper [1] (task: 901c9000 thread: 901ca000)
Stack: (0x901cbf98 to 0x901cc000)
bf80:                                                       900003f0 901cbfdc
bfa0: 90009b20 00000000 00000000 00000000 00000000 00000000 00400000 9000ebd0
bfc0: 9000ebd0 901cc000 00000000 00000000 00000000 00000000 00000000 90015cd4
bfe0: 00000000 00000000 00000000 00000000 00000000 90015cd4 9000037c 00000000
Call trace:
 [<900003f0>] kernel_init+0x74/0x1c0
 [<90015cd4>] do_exit+0x0/0x52c

Kernel panic - not syncing: Attempted to kill init!
