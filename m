Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0CHRdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 12:33:50 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:52969 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0CHRdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 12:33:46 -0500
Message-ID: <4B9534BA.4020903@oracle.com>
Date: Mon, 08 Mar 2010 09:32:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH -next] sound: fix opti92x-ad1848 build
References: <20100308152740.a007e8cb.sfr@canb.auug.org.au>
In-Reply-To: <20100308152740.a007e8cb.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B9534F1.009A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix 'else' placement in ifdef block so that build succeeds:

sound/isa/opti9xx/opti92x-ad1848.c:221: error: 'else' without a previous 'if'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Jaroslav Kysela <perex@perex.cz>
Cc:	Takashi Iwai <tiwai@suse.de>
---
 sound/isa/opti9xx/opti92x-ad1848.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20100308.orig/sound/isa/opti9xx/opti92x-ad1848.c
+++ linux-next-20100308/sound/isa/opti9xx/opti92x-ad1848.c
@@ -217,8 +217,9 @@ static int __devinit snd_opti9xx_init(st
 	if (isapnp && chip->mc_base)
 		/* PnP resource gives the least 10 bits */
 		chip->mc_base |= 0xc00;
+	else
 #endif	/* CONFIG_PNP */
-	else {
+	{
 		chip->mc_base = 0xf8c;
 		chip->mc_base_size = opti9xx_mc_size[hardware];
 	}
