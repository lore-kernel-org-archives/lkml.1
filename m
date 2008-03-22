Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbYCVVFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbYCVVFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbYCVVDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:03:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:64504 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbYCVVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:03:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=i+fR/7HQiueKBID4yaF/5mcPqitzhWWFqp6BkL5rx5uHnXe3qRgdmTBGu8K3ewKwQYaHuOprpiOkH7dEfVsJGQvaEaoH1psyxC27D+jNoY8hoWvY+92b1ZeGW+pexuQRP+mGIHXYglKcl+LK5Rg8MgoeKfe1j984Fj6aA21k8Is=
Message-Id: <20080322210310.475826146@gmail.com>
References: <20080322210005.117475478@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 23 Mar 2008 00:00:06 +0300
From: gorcunov@gmail.com
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, gorcunov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [patch 1/4] x86: relocate_kernel_32.S - clear register in more elegant way
Content-Disposition: inline; filename=x86-remove-dead-code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/relocate_kernel_32.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/relocate_kernel_32.S	2008-03-22 20:58:02.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/relocate_kernel_32.S	2008-03-22 21:15:37.000000000 +0300
@@ -185,8 +185,7 @@ identity_mapped:
 	/* Set cr4 to a known state:
 	 * Setting everything to zero seems safe.
 	 */
-	movl	%cr4, %eax
-	andl	$0, %eax
+	xorl	%eax, %eax
 	movl	%eax, %cr4
 
 	jmp 1f

-- 
