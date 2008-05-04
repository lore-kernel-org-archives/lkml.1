Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbYEDUeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbYEDUeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 16:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYEDUeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 16:34:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34710 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbYEDUeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 16:34:10 -0400
Date: Sun, 4 May 2008 22:32:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [patch] video: cinergyT2 build fix
Message-ID: <20080504203245.GA19356@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86.git testing found the following build bug in v2.6.26-rc1:

  drivers/built-in.o: In function `cinergyt2_probe':
  cinergyT2.c:(.text+0xb6117): undefined reference to `input_allocate_device'
  cinergyT2.c:(.text+0xb6230): undefined reference to `input_register_device'
  cinergyT2.c:(.text+0xb623d): undefined reference to `input_free_device'

with the following config:

  http://redhat.com/~mingo/misc/config-Sun_May__4_22_06_54_CEST_2008.bad

The reason for the bug is that the cinergyT2 driver depends on 
CONFIG_INPUT functionality, but if INPUT is modular it's still possible 
to build CONFIG_DVB_CINERGYT2=y - which leads to missing symbols.

The solution is to make DVB_CINERGYT2 dependent on INPUT.

[ This solves the build problem - i have not tested the driver on this card. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/dvb/cinergyT2/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/media/dvb/cinergyT2/Kconfig
===================================================================
--- linux.orig/drivers/media/dvb/cinergyT2/Kconfig
+++ linux/drivers/media/dvb/cinergyT2/Kconfig
@@ -1,6 +1,6 @@
 config DVB_CINERGYT2
 	tristate "Terratec CinergyT2/qanu USB2 DVB-T receiver"
-	depends on DVB_CORE && USB
+	depends on DVB_CORE && USB && INPUT
 	help
 	  Support for "TerraTec CinergyT2" USB2.0 Highspeed DVB Receivers
 
