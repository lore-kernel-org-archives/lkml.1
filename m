Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbXGWAdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbXGWAdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763691AbXGWAcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:32:51 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41502 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762882AbXGWAcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:32:50 -0400
Date: Mon, 23 Jul 2007 02:32:15 +0200
From: Adrian Bunk <bunk@stusta.de>
To: James Smart <James.Smart@Emulex.Com>,
       James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: 2.6.23 regression: lpfc_sli.c: off-by-10
Message-ID: <20070723003215.GQ26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following off-by-10
in drivers/scsi/lpfc/lpfc_sli.c:


<--  snip  -->

...
static int
lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
                            struct lpfc_iocbq *saveq)
{
...
                        saveq->context3 = lpfc_sli_replace_hbqbuff(phba,
                                                irsp->un.ulpWord[15]);
...

<--  snip  -->


due to the following code in drivers/scsi/lpfc/lpfc_hw.h:


<--  snip  -->

...
#define IOCB_WORD_SZ    8
...
typedef struct _IOCB {  /* IOCB structure */
...
                uint32_t ulpWord[IOCB_WORD_SZ - 2];     /* generic 6 'words' */
...

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

