Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZHNL60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZHNL60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbZHNL60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:58:26 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:58446 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbZHNL6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=v6zVAht2e+9O4SulnIWLPAkcOfRBv9VpecWvRDi3+T/FumPAsfJWIhQH4zNoohgYfV
         5YzFNx2u8hg8WEp2ZlxNLaqCX/QsGH+BEdejJy62uWKqVl7JJaoi9LinEVZEaOJSSIbQ
         VP8mbAbLOYPyTO+SIiIX/YzRLfH+t1oi6Unu0=
Message-ID: <4A85525A.9030601@gmail.com>
Date: Fri, 14 Aug 2009 14:02:34 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] icom: bit and/or confusion?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, if any bit other than CMD_SND_BREAK was set, CMD_SND_BREAK
was not unset.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I think meant was: If CMD_SND_BREAK is set, unset it. Correct?

// vi drivers/serial/icom.h +137
#define CMD_SND_BREAK                0x04

diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index cd1b6a4..060f4e3 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -617,7 +617,7 @@ static void shutdown(struct icom_port *icom_port)
 	 * disable break condition
 	 */
 	cmdReg = readb(&icom_port->dram->CmdReg);
-	if ((cmdReg | CMD_SND_BREAK) == CMD_SND_BREAK) {
+	if (cmdReg & CMD_SND_BREAK) {
 		writeb(cmdReg & ~CMD_SND_BREAK, &icom_port->dram->CmdReg);
 	}
 }
