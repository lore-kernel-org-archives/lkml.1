Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZETKab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZETKab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZETKaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:30:23 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64076 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbZETKaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=LBXKCX/JX8/C1v+4uNoZcdGmvlA9DdXjTh+oVYhuaG4IQCRMWK/b6K9jfadOscEZlq
         uDlzPQtVUQ5NKIlHpKt2rPqJRFwJRfz7yrxio7dIKz3BIhP+rDNjxQPjlIxHWuS9rzoJ
         pRMsBCGiFeMXsROXWNPSR/LqF4NeSq0qeURcE=
MIME-Version: 1.0
Date: Wed, 20 May 2009 11:30:21 +0100
Message-ID: <5c43c2d40905200330p5b14be2ey567bc493374e09b3@mail.gmail.com>
Subject: Are the cast necessary in function "kfree"?
From: =?ISO-8859-1?Q?Andr=E9_Lopes?= <andre.neo.net@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. This is my first post :-)

I was reading this doc (/linux-2.6/Documentation/scsi/ChangeLog.lpfc),
when I found this phrase: "Replace some kfree((void*)ptr) with
kfree(ptr)."

After that I created a script to detect this situation, in Linux
source code. The results were:

arch/mips/alchemy/common/dbdma.c:408:        kfree((const void *)desc_base);
arch/mips/alchemy/common/dbdma.c:834:    kfree((void *)ctp->chan_desc_base);
arch/s390/include/asm/idals.h:110:        kfree((void *)(unsigned
long) ccw->cda);
arch/powerpc/mm/pgtable_32.c:90:    kfree((void *)pgd);
drivers/ide/ide-acpi.c:369:    kfree((void *)obj_loc);
drivers/net/vxge/vxge-config.c:4962:        kfree((void *)p);
drivers/net/vxge/vxge-config.h:1970:    kfree((void *)tmp);
drivers/net/wan/pc300_tty.c:699:                kfree((void *)buf);
drivers/net/wireless/zd1211rw/zd_chip.c:149:    kfree((void *)a16);
drivers/net/lance.c:367:    kfree((void*)lp->rx_buffs);
drivers/net/lance.c:742:    kfree((void*)lp->rx_buffs);
drivers/net/ucc_geth.c:1890:                kfree((void
*)ugeth->tx_bd_ring_offset[i]);
drivers/net/ucc_geth.c:1920:                kfree((void
*)ugeth->rx_bd_ring_offset[i]);
drivers/s390/char/vmur.c:188:        kfree((void *)(addr_t) ptr->cda);
drivers/block/paride/bpck6.c:227:    kfree((void *)(pi->private));
drivers/infiniband/hw/cxgb3/iwch_provider.c:449:        kfree((void *)
(unsigned long) mhp->kva);
drivers/staging/epl/EplTarget.h:99:#define EPL_FREE(ptr)
kfree((void *)ptr)
drivers/video/console/fbcon.c:960:                kfree((void *) softback_buf);
drivers/video/console/fbcon.c:3428:    kfree((void *)softback_buf);
drivers/video/au1100fb.c:614:    kfree((void*)fbdev);
drivers/pci/rom.c:259:        kfree((void*)(unsigned long)res->start);
drivers/isdn/hisax/config.c:1272:        kfree((void *) cards[cardnr].cs);
drivers/isdn/hisax/fsm.c:47:    kfree((void *) fsm->jumpmatrix);
drivers/isdn/mISDN/fsm.c:54:    kfree((void *) fsm->jumpmatrix);
net/sched/ematch.c:401:                kfree((void *) em->data);
net/sched/em_meta.c:577:    kfree((void *) v->val);
sound/oss/sh_dac_audio.c:325:    kfree((void *)data_buffer);
sound/pci/ice1712/ak4xxx.c:158:        kfree((void*)ak->private_value[0]);
sound/pci/emu10k1/emufx.c:1724:        kfree((void __force *)icode->gpr_map);
sound/pci/emu10k1/emufx.c:2345:        kfree((void __force *)icode->gpr_map);

The prototype for kfree() is:
#include<linux/slab.h>
void kfree(const void *objp)

These casts are not necessary...I think so. If it's yes, can we apply
patch's to clean-up this?

Thanks.
