Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbYA3O5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbYA3O5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYA3O46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:56:58 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:41515 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbYA3O45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:56:57 -0500
Date: Wed, 30 Jan 2008 15:56:56 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: Add support for DIF CRC
In-Reply-To: <yq14pcv94sp.fsf@sermon.lab.mkp.net>
Message-ID: <Pine.LNX.4.64.0801301555450.15249@fbirervta.pbzchgretzou.qr>
References: <yq14pcv94sp.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2008 02:00, Martin K. Petersen wrote:
>diff -r f5ec697e8b10 include/linux/crc-t10dif.h
>--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
>+++ b/include/linux/crc-t10dif.h	Tue Jan 29 13:26:19 2008 -0500
>@@ -0,0 +1,9 @@
>+#ifndef _LINUX_CRC_T10DIF_H
>+#define _LINUX_CRC_T10DIF_H
>+
>+#include <linux/types.h>
>+
>+const __u16 t10_dif_crc_table[256];
>+__u16 crc_t10dif(unsigned char const *, size_t);
>+
>+const __u16 t10_dif_crc_table[256] = {
...
>+};
>+
>+__u16 crc_t10dif(const unsigned char *buffer, size_t len)
>+{
...
>+}
>+
>+EXPORT_SYMBOL(crc_t10dif);


One minor nitpick still: if t10_dif_crc_table is not EXPORT_SYMBOLed,
it should be static, since I do not see a reason to only make it
available to built-in code.

So either make the table static too, or EXPORT it. I am not sure if
any code needs to access the table directly, though, so I'd be going
for the static.
