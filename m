Return-Path: <linux-kernel-owner+w=401wt.eu-S1750876AbXBSKcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876AbXBSKcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbXBSKcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:32:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:57167 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbXBSKcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:32:53 -0500
Subject: [PATCH 12/13] KVM: SVM: intercept SMI to handle it at host level
From: Avi Kivity <avi@qumranet.com>
Date: Mon, 19 Feb 2007 10:32:52 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45D979D3.2020907@qumranet.com>
In-Reply-To: <45D979D3.2020907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070219103252.5E09625016B@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch changes the SVM code to intercept SMIs and handle it
outside the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c
+++ linux-2.6/drivers/kvm/svm.c
@@ -486,6 +486,7 @@ static void init_vmcb(struct vmcb *vmcb)
 
 	control->intercept = 	(1ULL << INTERCEPT_INTR) |
 				(1ULL << INTERCEPT_NMI) |
+				(1ULL << INTERCEPT_SMI) |
 		/*
 		 * selective cr0 intercept bug?
 		 *    	0:   0f 22 d8                mov    %eax,%cr3
