Return-Path: <linux-kernel-owner+w=401wt.eu-S1762288AbXEOMpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762288AbXEOMpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXEOMpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:45:33 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:42283 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXEOMpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:45:32 -0400
Message-ID: <4649AB60.4090103@sw.ru>
Date: Tue, 15 May 2007 16:45:20 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: [patch i2o 4/6] i2o proc reading oops
References: <4649AA6C.2080808@sw.ru>
In-Reply-To: <4649AA6C.2080808@sw.ru>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fixed oops on reading from some i2o proc files (i2o_seq_show_driver_store() and
other) because their handlers uses "exec" field in struct i2o_controller

Signed-off-by:	Vasily Averin <vvs@sw.ru>

--- lk2.6/drivers/message/i2o/exec-osm.c
+++ lk2.6/drivers/message/i2o/exec-osm.c
@@ -339,6 +339,8 @@ static int i2o_exec_probe(struct device
 	rc = device_create_file(dev, &dev_attr_product_id);
 	if (rc) goto err_vid;

+	i2o_dev->iop->exec = i2o_dev;
+
 	return 0;

 err_vid:
