Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbXKFNvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbXKFNvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 08:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXKFNvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 08:51:41 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:16976 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbXKFNvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 08:51:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=OTOvOX2Uf5h4UPLd3d9BomkFlHpCWIAgvuWLagovRx9ozwMIMdL8h9eoaOcf6zZsFbGitZ7DVT0eNmk9yK2nh4FM04abYnEKrI0gNSN4FqCFAxikK2fRXuUBVuyUgCL00ZolWqbzSLDlaZiOsdizP5m1inC4JgIBuJLlOZmrtjw=
Message-ID: <47307166.9010001@googlemail.com>
Date: Tue, 06 Nov 2007 14:51:34 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
In-Reply-To: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm snapshot broken-out-2007-11-06-02-32.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-06-02-32.tar.gz
> 

Some warnings ( still building :) )

..

arch/x86/Kconfig.i386:178:warning: 'select' used by config symbol 'X86_RDC321X' refers to undefined symbol 'GENERIC_GPIO'

...

...

fs/buffer.c: In function '__getblk_slow':
fs/buffer.c:1126: warning: integer constant is too large for 'unsigned long' type

that is :

#if (BITS_PER_LONG == 32) && defined(CONFIG_LBD)
        if ((block >> (PAGE_CACHE_SHIFT - bdev->bd_inode->i_blkbits)) &
                        0xffffffff00000000UL) { <-- ULL ?

...

...

fs/reiser4/tree.c: In function 'check_tree_pointer':
fs/reiser4/tree.c:807: warning: passing argument 1 of 'coord_clear_iplug' discards qualifiers from pointer target type
fs/reiser4/export_ops.c:25: warning: 'object_on_wire_done' defined but not used
fs/reiser4/export_ops.c:36: warning: 'decode_inode' defined but not used
fs/reiser4/export_ops.c:69: warning: 'reiser4_decode_fh' defined but not used
fs/reiser4/export_ops.c:261: warning: 'reiser4_get_dentry' defined but not used
fs/reiser4/plugin/file/cryptcompress.c: In function 'align_or_cut_overhead':
fs/reiser4/plugin/file/cryptcompress.c:847: warning: 'oh' may be used uninitialized in this function
fs/reiser4/plugin/item/item.c: In function 'obtain_item_plugin':
fs/reiser4/plugin/item/item.c:70: warning: passing argument 1 of 'coord_set_iplug' discards qualifiers from pointer target type

...


Some more but the rest exist in Linus git so I assume these are known.


Regards,

Gabriel C
