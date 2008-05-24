Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbYEXPon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbYEXPon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbYEXPl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:41:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:10460 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040AbYEXPlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:41:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=dop+c7C9YZjJ485tZQERS4P31u4UIuz8GA2VnGPckq1Rb9ag08k+q9opcp9zIl6Oq3fU4zm1fEnHhXHxacRUbj87ypqTq7jIwylGiEWuYpg09ajuzSBN9JNJ73CmFc2rMcMquDKmLN2N0bVvMObSRoWVJLF1weezZyHZpZSAE7c=
References: <20080524153630.669797039@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 24 May 2008 19:36:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 07/11] x86: nmi_32.c - unknown_nmi_panic_callback should always panic on being called
Content-Disposition: inline; filename=nmi-32-do-panic-on-unknown-nmi
Message-ID: <48383741.0405560a.1421.7c58@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_32.c	2008-05-24 13:07:08.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_32.c	2008-05-24 13:10:10.000000000 +0400
@@ -425,7 +425,7 @@ static int unknown_nmi_panic_callback(st
 	char buf[64];
 
 	sprintf(buf, "NMI received for unknown reason %02x\n", reason);
-	die_nmi(buf, regs, 0);
+	die_nmi(buf, regs, 1); /* Always panic here */
 	return 0;
 }
 

-- 
