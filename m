Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbYHOXoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbYHOXoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 19:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYHOXnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 19:43:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:33084 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbYHOXne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 19:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oAr3xc5OU0INPw+S1fijRrXUpxhocQmnGL67bF4fwWhvcnWm1UH1xmAFSl+HGgA+3d
         F7kYhVF0KP0oaLGzAsVWtyA3fVykW3avXeHjKN2AUQnih9BTZicq1667bqaFt4mMNOTY
         q52bqoiBHPsBqWEwIFh3gZ6/GsMLNvNtoqfbA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/7] x86: ordering functions in io_apic_32.c - fix
Date: Fri, 15 Aug 2008 16:42:36 -0700
Message-Id: <1218843762-14650-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218843762-14650-1-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218843762-14650-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add calling setup_msi_irq back to arch_setup_msi_irq

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
+++ linux-2.6/arch/x86/kernel/io_apic_32.c
@@ -2686,7 +2695,6 @@ static unsigned int build_irq_for_pci_de
 
 int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 {
-	struct msi_msg msg;
 	int irq, ret;
         unsigned int irq_want;
 
@@ -2697,6 +2705,7 @@ int arch_setup_msi_irq(struct pci_dev *d
 	if (irq == 0)
 		return -1;
 
+	ret = setup_msi_irq(dev, desc, irq);
 	if (ret < 0) {
 		destroy_irq(irq);
 		return ret;
