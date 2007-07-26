Return-Path: <linux-kernel-owner+w=401wt.eu-S934815AbXGZUaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934815AbXGZUaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934536AbXGZUaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:30:05 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:34423 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934518AbXGZUaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:30:03 -0400
Date: Thu, 26 Jul 2007 23:30:01 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: integer overflow in i2o_block
Message-ID: <Pine.SOC.4.64.0707262322240.7082@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Got this warning on 32-bit ppc, seems real? And it seems I2O 
subsystem has no maintainer (only DPT_I2O has one)?

  CC [M]  drivers/message/i2o/i2o_block.o
drivers/message/i2o/i2o_block.c: In function 'i2o_block_transfer':
drivers/message/i2o/i2o_block.c:837: warning: integer overflow in expression

The line in question is
msg->u.head[1] = cpu_to_le32(I2O_CMD_PRIVATE << 24 | HOST_TID << 12 | tid);
and I2O_CMD_PRIVATE is defined as 0xFF. This gets "0xFF0100 | tid" and 
fits into 32-bit unsigned but not into 32-bit signed integer properly.
Target value head[*] is defined as u32 so the claculation does not fit 
during computation? Should we mark the shiftable inputas as unsigned?

-- 
Meelis Roos (mroos@linux.ee)
