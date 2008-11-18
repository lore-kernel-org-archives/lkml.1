Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbYKRAzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbYKRAzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYKRAyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:54:52 -0500
Received: from mail.gmx.net ([213.165.64.20]:38311 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751076AbYKRAyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:54:52 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18Jx/BuzHwJ1z4zEMN0UDsisxe7lhm5lZ2U6QLlFU
	/JHHp/m0QZ1d1m
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: patch scsi-qla2xxx-correct-atmel-flash-part-handling.patch added to 2.6.27-stable tree
Date: Tue, 18 Nov 2008 01:54:44 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, lalit.chandivade@qlogic.com,
       andrew.vasquez@qlogic.com, James.Bottomley@hansenpartnership.com,
       stable@kernel.org
References: <20081117055003.2F349145446A@imap.suse.de>
In-Reply-To: <20081117055003.2F349145446A@imap.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811180154.49395.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Montag, 17. November 2008, gregkh@suse.de wrote:
> 
> This is a note to let you know that we have just queued up the patch titled
> 
>      Subject: SCSI: qla2xxx: Correct Atmel flash-part handling.
> 
> to the 2.6.27-stable tree.  Its filename is
> 
>      scsi-qla2xxx-correct-atmel-flash-part-handling.patch

This unfortunately breaks the build.

drivers/scsi/qla2xxx/qla_sup.c: In function 'qla2xxx_get_flash_info':
drivers/scsi/qla2xxx/qla_sup.c:628: error: 'scsi_qla_host_t' has no member named 'fdt_odd_index'
make[6]: *** [drivers/scsi/qla2xxx/qla_sup.o] Error 1
make[5]: *** [drivers/scsi/qla2xxx] Error 2
make[4]: *** [drivers/scsi] Error 2

> A git repo of this tree can be found at 
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> 
> From 821b3996001508e872582dcafc7575021f122728 Mon Sep 17 00:00:00 2001
> From: Lalit Chandivade <lalit.chandivade@qlogic.com>
> Date: Fri, 24 Oct 2008 15:13:44 -0700
> Subject: SCSI: qla2xxx: Correct Atmel flash-part handling.
> 
> From: Lalit Chandivade <lalit.chandivade@qlogic.com>
> 
> commit 821b3996001508e872582dcafc7575021f122728 upstream.
> 
> Use correct block size (4K) for erase command 0x20 for Atmel
> Flash. Use dword addresses for determining sector boundary.
> 
> Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/scsi/qla2xxx/qla_def.h |    1 -
>  drivers/scsi/qla2xxx/qla_sup.c |   19 +++++++------------
>  2 files changed, 7 insertions(+), 13 deletions(-)
> 
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2546,7 +2546,6 @@ typedef struct scsi_qla_host {
>  	uint8_t		fcode_revision[16];
>  	uint32_t	fw_revision[4];
>  
> -	uint16_t	fdt_odd_index;
>  	uint32_t	fdt_wrt_disable;
>  	uint32_t	fdt_erase_cmd;
>  	uint32_t	fdt_block_size;


2.6.27.7-rc2:
$ grep -nR -A 3 -B 3 fdt_odd_index drivers/scsi/qla2xxx/
drivers/scsi/qla2xxx/qla_sup.c-628-     DEBUG2(qla_printk(KERN_DEBUG, ha, "Flash[MID]: (0x%x/0x%x) erase=0x%x "
drivers/scsi/qla2xxx/qla_sup.c-629-         "pro=%x upro=%x idx=%d wrtd=0x%x blk=0x%x.\n", man_id, flash_id,
drivers/scsi/qla2xxx/qla_sup.c-630-         ha->fdt_erase_cmd, ha->fdt_protect_sec_cmd,
drivers/scsi/qla2xxx/qla_sup.c:631:         ha->fdt_unprotect_sec_cmd, ha->fdt_odd_index, ha->fdt_wrt_disable,
drivers/scsi/qla2xxx/qla_sup.c-632-         ha->fdt_block_size));
drivers/scsi/qla2xxx/qla_sup.c-633-}
drivers/scsi/qla2xxx/qla_sup.c-634-

Regards
	Stefan Lippers-Hollmann
