Return-Path: <linux-kernel-owner+w=401wt.eu-S936390AbXFGCOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936390AbXFGCOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 22:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935510AbXFGCOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 22:14:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:53059 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbXFGCOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 22:14:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,391,1175497200"; 
   d="scan'208";a="94260577"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH] KVM - Fix rmode_tss_base declaration
Date: Thu, 7 Jun 2007 10:13:42 +0800
Message-ID: <B30DA1341B0CFA4893EF8A36B40B5C5D013A32CB@pdsmsx411.ccr.corp.intel.com>
In-Reply-To: <20070606191925.GA8989@c2.user-mode-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH] KVM - Fix rmode_tss_base declaration
Thread-Index: AceocNjdLwCMqFCHQIeWffjFYgelsAAOIr6Q
References: <20070606191925.GA8989@c2.user-mode-linux.org>
From: "Li, Xin B" <xin.b.li@intel.com>
To: "Jeff Dike" <jdike@addtoit.com>, <avi@qumranet.com>
Cc: <kvm-devel@lists.sourceforge.net>, "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Jun 2007 02:13:46.0159 (UTC) FILETIME=[7A816BF0:01C7A8A9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
>The long return value of rmode_tss_base is truncated by its declared
>return type of int.
>
>Signed-off-by: Jeff Dike <jdike@linux.intel.com>
>--
> drivers/kvm/vmx.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>Index: kvm/drivers/kvm/vmx.c
>===================================================================
>--- kvm.orig/drivers/kvm/vmx.c
>+++ kvm/drivers/kvm/vmx.c
>@@ -884,7 +884,7 @@ static void enter_pmode(struct kvm_vcpu 
> 	vmcs_write32(GUEST_CS_AR_BYTES, 0x9b);
> }
> 
>-static int rmode_tss_base(struct kvm* kvm)
>+static unsigned long rmode_tss_base(struct kvm* kvm)

Should use gpa_t instead.
-Xin 
