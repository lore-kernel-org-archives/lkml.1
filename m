Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbYDKWLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbYDKWLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 18:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbYDKWLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 18:11:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:44823 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158AbYDKWLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 18:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=C4GKscyhd8irOc4IG1VlbQjMpnmLu1g+VFpkWNtcmjFjT4RrZvDvw5JxQ2dGA/uY2zpjmMI/ISSIZSfAUa52h3IujCOaJWIvFN7zoC6T6TysPv/6DIzC1EWkJutdszKvFlgMucK0acPx51RMDhk5SO01xEBWSUd6h2AtYtdygXs=
Reply-To: yhlu.kernel@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86_64: don't need set default res if only have one root bus
Date: Fri, 11 Apr 2008 15:14:52 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804111514.53680.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

only one root bus, don't need to split that root resources.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/pci/k8-bus_64.c b/arch/x86/pci/k8-bus_64.c
index 7ed7f51..c433982 100644
--- a/arch/x86/pci/k8-bus_64.c
+++ b/arch/x86/pci/k8-bus_64.c
@@ -69,7 +69,8 @@ void set_pci_bus_resources_arch_default(struct pci_bus *b)
 	int j;
 	struct pci_root_info *info;
 
-	if (!pci_root_num)
+	/* if only one root bus, don't need to anything */
+	if (pci_root_num < 2)
 		return;
 
 	for (i = 0; i < pci_root_num; i++) {
