Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbYCaViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbYCaViT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbYCaViK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:38:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:61228 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbYCaViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jJinrxEI2e9gC4euK+ZjbhgbkbDFQGvMtrVcVdH85ecETOo+UOQcpiwj46BhkpMJbqF99l7KothPoOx5lfiFAI2+VU446VohrcaQYCmc5dq/LRn6nHQ/E0Lgj3vYi39wTlPqotIl3xledzXXRiVxfsCe7ba33QgWTcJ9E43dNpk=
Date: Tue, 1 Apr 2008 01:38:01 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dtor@mail.ru
Subject: [PATCH] Fix tosakbd suspend
Message-ID: <20080331213801.GA9372@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/input/keyboard/tosakbd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/tosakbd.c b/drivers/input/keyboard/tosakbd.c
index 3884d1e..306cbe8 100644
--- a/drivers/input/keyboard/tosakbd.c
+++ b/drivers/input/keyboard/tosakbd.c
@@ -210,6 +210,9 @@ static int tosakbd_suspend(struct platform_device *dev, pm_message_t state)
 
 	del_timer_sync(&tosakbd->timer);
 
+	PGSR1 = (PGSR1 & ~TOSA_GPIO_LOW_STROBE_BIT);
+	PGSR2 = (PGSR2 & ~TOSA_GPIO_HIGH_STROBE_BIT);
+
 	return 0;
 }
 
-- 
1.5.4.4


-- 
With best wishes
Dmitry

