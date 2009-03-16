Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZCPPsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZCPPsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 11:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZCPPs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 11:48:29 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:40015 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbZCPPs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:48:29 -0400
Date: Mon, 16 Mar 2009 16:48:18 +0100
From: Jan Kasprzak <kas@fi.muni.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH] drivers/char/mxser.c: Fix reference counting
Message-ID: <20090316154817.GX7301@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 16 Mar 2009 16:48:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

In drivers/char/mxser.c:mxser_check_modem_status() there is a call
to tty_port_tty_get without a corresponding tty_put() call. This causes
the device to return -EIO on the second open(2) call.

Signed-off-by: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/mxser.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 402c9f2..de6f565 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -848,6 +848,7 @@ static void mxser_check_modem_status(struct tty_struct *tty,
 			}
 		}
 	}
+	tty_kref_put(tty);
 }
 
 static int mxser_startup(struct tty_struct *tty)
-- 
1.5.3.3

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
>>  If you find yourself arguing with Alan Cox, you’re _probably_ wrong.  <<
>>     --James Morris in "How and Why You Should Become a Kernel Hacker"  <<
