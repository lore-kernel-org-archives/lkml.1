Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYCZHp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYCZHp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYCZHps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:45:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64244 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbYCZHps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:45:48 -0400
Message-ID: <47E9FEF5.4080606@cn.fujitsu.com>
Date: Wed, 26 Mar 2008 15:44:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] set relay file can not be read by pread(2)
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:
	I found that relay files can be read by pread(2). I fix it,
for relay files are not capable of seeking.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

--- linux-2.6.24/kernel/relay.c.org	2008-01-25 06:58:37.000000000 +0800
+++ linux-2.6.24/kernel/relay.c	2008-03-17 23:53:14.000000000 +0800
@@ -741,7 +741,7 @@ static int relay_file_open(struct inode 
 	kref_get(&buf->kref);
 	filp->private_data = buf;
 
-	return 0;
+	return nonseekable_open(inode, filp);
 }
 
 /**

