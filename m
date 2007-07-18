Return-Path: <linux-kernel-owner+w=401wt.eu-S935835AbXGRXAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935835AbXGRXAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763712AbXGRW6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:58:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:23349 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763950AbXGRW6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:58:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GubuyFo0f2Nh22X4K15hOKQJgGLA0hDXS1qvQ64nlOFaBlNigiKbsyvsfvFs1FJ6Fv46tXDXqnBSat6KIy8k9C5ZHcHo1Fr1bwu6k7a0B2FyrQ2JWK8OoJoo+MVgASMYVo5qOEbSI9l1VfPJp8L9JFN2VsKcMfBYnOQyHB8XpeQ=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Corey Minyard <minyard@mvista.com>
Subject: [PATCH][IPMI] Fix mem leak in try_init_dmi() code
Date: Thu, 19 Jul 2007 00:57:15 +0200
User-Agent: KMail/1.9.7
Cc: Christian Krafft <krafft@de.ibm.com>,
       openipmi-developer@lists.sourceforge.net, minyard@wf-rch.cirr.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707190057.16051.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

If we ever hit the "default:" case in the switch in try_init_dmi(), 
then we'll leak the storage allocated with kzalloc() and assigned 
to 'info'. 

Note: patch has been compile tested only.

Please consider merging upstream :-)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/char/ipmi/ipmi_si_intf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c 
b/drivers/char/ipmi/ipmi_si_intf.c
index 4edfdda..96d2f9e 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2050,6 +2050,7 @@ static __devinit void try_init_dmi(struct dmi_ipmi_data 
*ipmi_data)
 		info->si_type = SI_BT;
 		break;
 	default:
+		kfree(info);
 		return;
 	}
 


