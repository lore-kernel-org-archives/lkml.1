Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbZCXM3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbZCXM3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbZCXM3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:29:20 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:46419 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbZCXM3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:29:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=V6y/t7XNkRx9eCekF5KSW+HpMSA2rR60iaR1kmv1VJxhR+BmqXdkvY7xyM4YiZ3FuJ
         KbFrkCtl9F34aAu01KBzMtnMQKB4w2Mp4yQCexTbKEtWYJrCHe/0u+lS3J618uYHQexh
         EIK+JadkJy/O+GKmv4id1LcWuRMPyEOoTRn04=
MIME-Version: 1.0
Date: Tue, 24 Mar 2009 15:29:17 +0300
Message-ID: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
Subject: Dereferencing freed memory bugs
From: Dan Carpenter <error27@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: eteo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I added a check to smatch (http://repo.or.cz/w/smatch.git/) to check
for when we dereference
freed memory.

drivers/dma/dmatest.c +410 dmatest_exit(7) 'dtc'
drivers/dma/dmatest.c +412 dmatest_exit(9) 'dtc'
drivers/infiniband/hw/nes/nes_cm.c +563 nes_cm_timer_tick(121) 'cm_node'
drivers/infiniband/hw/nes/nes_cm.c +621 nes_cm_timer_tick(179) 'cm_node'
drivers/scsi/dpt_i2o.c +246 adpt_detect(58) 'pHba'
drivers/scsi/dpt_i2o.c +266 adpt_detect(78) 'pHba'
drivers/scsi/dpt_i2o.c +1236 adpt_i2o_delete_hba(78) 'pHba'
drivers/usb/host/ehci-hcd.c +1661 itd_complete(79) 'stream'
drivers/usb/host/ehci-hcd.c +2036 sitd_complete(64) 'stream'
drivers/uwb/reset.c +193 __uwb_rc_cmd(26) 'cmd'
net/netfilter/nfnetlink_log.c +341 __nfulnl_flush(5) 'inst'
net/netfilter/xt_recent.c +273 recent_mt(69) 'e'
drivers/media/radio/radio-si470x.c +1144 si470x_fops_release(32) 'radio'
drivers/media/radio/radio-si470x.c +1722
si470x_usb_driver_disconnect(13) 'radio'
drivers/media/radio/radio-si470x.c +1144 si470x_fops_release(32) 'radio'
drivers/media/radio/radio-si470x.c +1722
si470x_usb_driver_disconnect(13) 'radio'
drivers/media/video/cpia_pp.c +777 cpia_pp_detach(28) 'cpia'
drivers/media/video/s2255drv.c +1711 s2255_destroy(42) 'dev'
drivers/mtd/mtd_blkdevs.c +389 register_mtd_blktrans(49) '*tr->blkcore_priv'
drivers/net/usb/hso.c +2616 hso_free_tiomget(5) 'tiocmget'

These mostly seem like real bugs.

regards,
dan carpenter
