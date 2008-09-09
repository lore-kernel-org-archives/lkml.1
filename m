Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbYIIUsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbYIIUsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYIIUsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:48:15 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41122 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbYIIUsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:48:15 -0400
In-Reply-To: <48C6D301.305@gmail.com>
Subject: Re: [PATCH] [CELL] oprofile: test for flag instead of negative on unsigned
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, paulus@samba.org,
       roel kluin <roel.kluin@gmail.com>, maynardj@linux.vnet.ibm.com
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF8A54213D.B8B798D3-ON862574BF.00714361-862574BF.00724820@us.ibm.com>
From: Maynard Johnson <mpjohn@us.ibm.com>
Date: Tue, 9 Sep 2008 15:48:08 -0500
X-MIMETrack: Serialize by Router on d27ml103/27/M/IBM(Release 8.0.1|February 07, 2008) at
 09/09/2008 03:48:09 PM
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,
This patch was originally submitted some time back, and I gave my approval
for it.  The last I heard from you about it (on July 2), you said you were
queuing it up for 2.6.27.  Has it gotten upstream yet?

Thanks.
-Maynard


--------------------------------------------------------------------------
roel kluin <roel.kluin@gmail.com> wrote on 09/09/2008 02:48:17 PM:

> vi arch/powerpc/oprofile/cell/vma_map.c +46
>
> And you'll find this comment in vma_map_lookup():
>
> Default the offset to the physical address + a flag value.
> Addresses of dynamically generated code can't be found in the vma
> map.  For those addresses the flagged value will be sent on to
> the user space tools so they can be reported rather than just
> thrown away.
>
> Returned is the flag value 0x10000000 + vma when not found.
>
> The test for negative overlay_tbl_offset does not work
> because it is unsigned.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/arch/powerpc/oprofile/cell/vma_map.c
> b/arch/powerpc/oprofile/cell/vma_map.c
> index fff6666..41e0c22 100644
> --- a/arch/powerpc/oprofile/cell/vma_map.c
> +++ b/arch/powerpc/oprofile/cell/vma_map.c
> @@ -229,7 +229,7 @@ struct vma_to_fileoffset_map
> *create_vma_map(const struct spu *aSpu,
>      */
>     overlay_tbl_offset = vma_map_lookup(map, ovly_table_sym,
>                     aSpu, &grd_val);
> -   if (overlay_tbl_offset < 0) {
> +   if (overlay_tbl_offset >= 0x10000000) {
>        printk(KERN_ERR "SPU_PROF: "
>               "%s, line %d: Error finding SPU overlay table\n",
>               __func__, __LINE__);

