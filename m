Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbXGRIvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbXGRIvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbXGRIu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:50:57 -0400
Received: from ihemail4.lucent.com ([135.245.0.39]:55223 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbXGRIu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:50:56 -0400
Message-ID: <469DD41A.10506@alcatel-lucent.com>
Date: Wed, 18 Jul 2007 16:49:30 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to include sysmap in 2.6 kernel image
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jul 2007 08:50:35.0219 (UTC) FILETIME=[B4BF6A30:01C7C918]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Guys,

Recently, I'm working on xmon. The xmon needs sysmap for symbol lookup, 
however I don't know how to include sysmap to uImage. I looked the 
kernel source code for a while and found the kernel image need contain 
struct bi_record *rec. Everybody knows how to include this?

arch/ppc/kernel/setup.c::parse_bootinfo()

void parse_bootinfo(struct bi_record *rec)
{
       if (rec == NULL || rec->tag != BI_FIRST)
               return;
       while (rec->tag != BI_LAST) {
               ulong *data = rec->data;

               printk(KERN_INFO "%s:*********** 0x%08lx\n", 
__FUNCTION__, rec->tag);

               switch (rec->tag) {
               case BI_CMD_LINE:
                       strlcpy(cmd_line, (void *)data, sizeof(cmd_line));
                       break;
               case BI_SYSMAP:
                       sysmap = (char *)((data[0] >= (KERNELBASE)) ? 
data[0] :
                                         (data[0]+KERNELBASE));
                       sysmap_size = data[1];
                       break;
#ifdef CONFIG_BLK_DEV_INITRD
               case BI_INITRD:
                       initrd_start = data[0] + KERNELBASE;
                       initrd_end = data[0] + data[1] + KERNELBASE;
                       break;
#endif /* CONFIG_BLK_DEV_INITRD */
#ifdef CONFIG_PPC_MULTIPLATFORM
               case BI_MACHTYPE:
                       _machine = data[0];
                       break;
#endif
               case BI_MEMSIZE:
                       boot_mem_size = data[0];
                       break;
               }
               rec = (struct bi_record *)((ulong)rec + rec->size);
       }
}


Thanks,
Gavin
