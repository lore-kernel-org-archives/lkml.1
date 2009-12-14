Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbZLNTXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbZLNTXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932496AbZLNTW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:22:59 -0500
Received: from mail.perches.com ([173.55.12.10]:1178 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932494AbZLNTW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:22:58 -0500
Subject: suspect & tests
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 11:22:57 -0800
Message-ID: <1260818577.18538.35.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A grep for possibly misused & tests
	grep -rP --include=*.[ch] -n -e "[^\&]\&[\=]*\s*\!" *
shows some possible cases where && should
have been used instead:

arch/powerpc/platforms/pseries/lpar.c:309:	if ((rflags & _PAGE_NO_CACHE) & !(rflags & _PAGE_WRITETHRU))
arch/arm/mach-mxc91231/clock.c:265:	if (acs & !ads)
arch/arm/mach-s3c2440/mach-osiris-dvs.c:72:		if (old_dvs & !new_dvs ||
arch/arm/mach-s3c2440/mach-osiris-dvs.c:73:		    cur_dvs & !new_dvs) {
arch/arm/mach-davinci/board-da850-evm.c:183:	if (ui_card_detected & !HAS_MMC) {
drivers/scsi/libiscsi_tcp.c:423:	if (conn->datadgst_en &
	    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
drivers/media/video/omap24xxcam-dma.c:509:	if ((sglen < 0) || ((sglen > 0) & !sglist))
drivers/net/dm9000.c:615:		else if (dm->wake_state & !opts)
drivers/net/myri10ge/myri10ge.c:2845:					rdma_count += chop & !next_is_first;
fs/nilfs2/the_nilfs.c:516:	nilfs->ns_prot_seq = le64_to_cpu(sbp[valid[1] & !swp]->s_last_seq);
sound/soc/codecs/stac9766.c:233:		vra &= !0x04;

