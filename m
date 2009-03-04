Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZCDQ4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZCDQ4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 11:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZCDQ4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 11:56:30 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:50672 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZCDQ43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 11:56:29 -0500
Message-ID: <49AEB2E0.1030503@oracle.com>
Date: Wed, 04 Mar 2009 08:57:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-media@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] media/dm1105: uses ir_* functions, select VIDEO_IR
References: <20090304180630.047dac29.sfr@canb.auug.org.au>
In-Reply-To: <20090304180630.047dac29.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49AEB285.00C0:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

dm1105 uses the ir_*() functions, so it needs to select VIDEO_IR
to avoid build errors:

dm1105.c:(.text+0x26b7ac): undefined reference to `ir_input_keydown'
dm1105.c:(.text+0x26b7bc): undefined reference to `ir_input_nokey'
(.devinit.text+0x29982): undefined reference to `ir_codes_dm1105_nec'
(.devinit.text+0x2998a): undefined reference to `ir_input_init'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/dvb/dm1105/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090304.orig/drivers/media/dvb/dm1105/Kconfig
+++ linux-next-20090304/drivers/media/dvb/dm1105/Kconfig
@@ -8,6 +8,7 @@ config DVB_DM1105
 	select DVB_STB6000 if !DVB_FE_CUSTOMISE
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
 	select DVB_SI21XX if !DVB_FE_CUSTOMISE
+	select VIDEO_IR
 	help
 	  Support for cards based on the SDMC DM1105 PCI chip like
 	  DvbWorld 2002
