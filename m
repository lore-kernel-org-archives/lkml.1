Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYEQSZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYEQSZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 14:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYEQSZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 14:25:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47464 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYEQSZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 14:25:32 -0400
Date: Sat, 17 May 2008 20:25:31 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "P.V.Anthony" <pvantony@singnet.com.sg>
cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: Solved - How to change the FSINFO for nfsd?
In-Reply-To: <20080518015733.o7n8cvhomvgos8ow@mail.mindmedia.com.sg>
Message-ID: <alpine.LNX.1.10.0805172024440.15590@fbirervta.pbzchgretzou.qr>
References: <482332CD.4010706@singnet.com.sg> <20080509042238.GC21408@fieldses.org> <20080518015733.o7n8cvhomvgos8ow@mail.mindmedia.com.sg>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-05-17 19:57, P.V.Anthony wrote:
>
> pv at videoserver2 ~ $ diff -ruN
> /usr/src/linux-2.6.22-gentoo-r8/fs/nfsd/nfs3proc.c.org
> /usr/src/linux-2.6.22-gentoo-r8/fs/nfsd/nfs3proc.c
> --- /usr/src/linux-2.6.22-gentoo-r8/fs/nfsd/nfs3proc.c.org 2008-05-09
> 13:07:19.000000000 +0800
> +++ /usr/src/linux-2.6.22-gentoo-r8/fs/nfsd/nfs3proc.c 2008-05-13
> 23:54:56.000000000 +0800
> @@ -555,7 +555,7 @@
> resp->f_wtpref = max_blocksize;
> resp->f_wtmult = PAGE_SIZE;
> resp->f_dtpref = PAGE_SIZE;
> - resp->f_maxfilesize = ~(u32) 0;
> + resp->f_maxfilesize = 0xffffffffffffffff;

Hm, you could have just changed u32 to u64 :-)

> resp->f_properties = NFS3_FSF_DEFAULT;
>
> nfserr = fh_verify(rqstp, &argp->fh, 0, MAY_NOP);
> @@ -570,7 +570,7 @@
> if (sb->s_magic == 0x4d44 /* MSDOS_SUPER_MAGIC */) {
> resp->f_properties = NFS3_FSF_BILLYBOY;
> }
> - resp->f_maxfilesize = sb->s_maxbytes;
> + resp->f_maxfilesize = 0xffffffffffffffff;
> }
>
