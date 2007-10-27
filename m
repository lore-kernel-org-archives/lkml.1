Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbXJ0JjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbXJ0JjZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 05:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbXJ0JjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 05:39:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56267 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbXJ0JjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 05:39:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] compat_ioctl: fix block device compat ioctl regression
Date: Sat, 27 Oct 2007 11:38:05 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Philip Langdale <philipl@overt.org>
References: <47221F91.60401@overt.org> <200710270051.38748.arnd@arndb.de> <47228A9E.80505@overt.org>
In-Reply-To: <47228A9E.80505@overt.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710271138.06456.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/o6fpZ/ONEVR3GS+yQwuuUcqEvT+nGKzDdxhq
 tFHedx0yk/JxLYUMCn/qKXqwv+tV7jpvdtEikUzB0BdrztqsxM
 tzf9gDQ6n6AyC6bIsnuJQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip Langdale <philipl@overt.org>
The conversion of handlers to compat_blkdev_ioctl accidentally
disabled handling of most ioctl numbers on block devices because
of a typo. Fix the one line to enable it all again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

Mea Culpa. This should have been found by my testing, as it's clear
that most of my big patch never worked at all. Sorry for causing
problems for everyone involved here.

I'm attributing the patch to Philip, as he's the one who pointed
out to me what the fix is.

	Arnd <><

--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -581,7 +581,7 @@ static int compat_blkdev_driver_ioctl(struct inode *inode, struct file *file,
 {
 	int ret;
 
-	switch (arg) {
+	switch (cmd) {
 	case HDIO_GET_UNMASKINTR:
 	case HDIO_GET_MULTCOUNT:
 	case HDIO_GET_KEEPSETTINGS:
