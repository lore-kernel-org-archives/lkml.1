Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbYGRXao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbYGRXao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbYGRXah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:30:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:47808 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYGRXag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=iZBetSfPbfP+4QlzyCuuJLIbpzO2uF4Q782QQU/5Yl/f2kzbWy7mWMUVVdwoNBCUEF
         Xz2z9tOcL0IBwDP1Py3jZnQozkgrABodIW1WQ7BGFGuxuFanIa59A8lCPIjmaDg8G2CI
         oLE+1WuhDokWNw5Lp6rk2JaxHI+hFvj1pyc80=
Date: Sat, 19 Jul 2008 03:27:48 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: thomas.mingarelli@hp.com
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
Subject: [PATCH] hpwdt: don't use static flags
Message-ID: <20080718232748.GA18224@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static (read: global) is potential problem. Two threads can corrupt
each other's interrupt status, better avoid this.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/watchdog/hpwdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -420,7 +420,7 @@ static int __devinit detect_cru_service(void)
 static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 			    void *data)
 {
-	static unsigned long rom_pl;
+	unsigned long rom_pl;
 	static int die_nmi_called;
 
 	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)

