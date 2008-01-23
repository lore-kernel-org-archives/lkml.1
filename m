Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYAWFmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYAWFmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 00:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYAWFmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 00:42:40 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:42662 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbYAWFmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 00:42:39 -0500
Date: Tue, 22 Jan 2008 21:39:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: v4l-dvb-maintainer@linuxtv.org, lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH] radio: fix sf16fmi section mismatch
Message-Id: <20080122213939.59db650f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

isapnp_fmi_probe() is only called by fmi_init(), which is __init,
so isapnp_fmi_probe() can also be __init.

media/radio/radio-sf16fmi.c:
WARNING: vmlinux.o(.text+0x994e19): Section mismatch: reference to .init.data: (between 'isapnp_fmi_probe' and 'vidioc_s_tuner')
WARNING: vmlinux.o(.text+0x994e22): Section mismatch: reference to .init.data: (between 'isapnp_fmi_probe' and 'vidioc_s_tuner')
WARNING: vmlinux.o(.text+0x994e3a): Section mismatch: reference to .init.data:id_table (between 'isapnp_fmi_probe' and 'vidioc_s_tuner')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/radio/radio-sf16fmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc8-git5.orig/drivers/media/radio/radio-sf16fmi.c
+++ linux-2.6.24-rc8-git5/drivers/media/radio/radio-sf16fmi.c
@@ -321,7 +321,7 @@ static struct isapnp_device_id id_table[
 
 MODULE_DEVICE_TABLE(isapnp, id_table);
 
-static int isapnp_fmi_probe(void)
+static int __init isapnp_fmi_probe(void)
 {
 	int i = 0;
 
