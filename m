Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYBPRbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYBPRbs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbYBPRbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:31:41 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:33822 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755266AbYBPRbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:31:40 -0500
Date: Sat, 16 Feb 2008 23:01:32 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com, sds@tycho.nsa.gov,
       linuxppc-dev@ozlabs.org, apw@shadowen.org
Subject: [PATCH]2.6.25-rc2-mm1 - Build Failure at security/keys/compat.c on powerpc
Message-ID: <20080216173132.GA13326@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The 2.6.25-rc2-mm1 kernel build fails on the powerpc(s) 

  CC      security/keys/compat.o
security/keys/compat.c: In function ‘compat_sys_keyctl’:
security/keys/compat.c:83: error: implicit declaration of function ‘keyctl_get_security’
make[2]: *** [security/keys/compat.o] Error 1
make[1]: *** [security/keys] Error 2
make: *** [security] Error 2

The keys-add-keyctl-function-to-get-a-security-label.patch is causing
this build failure.

I have tested the patch for the build failure only

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.25-rc2/security/keys/internal.h	2008-02-17 05:03:30.000000000 +0530
+++ linux-2.6.25-rc2/security/keys/~internal.h	2008-02-17 05:46:16.000000000 +0530
@@ -155,6 +155,8 @@ extern long keyctl_negate_key(key_serial
 extern long keyctl_set_reqkey_keyring(int);
 extern long keyctl_set_timeout(key_serial_t, unsigned);
 extern long keyctl_assume_authority(key_serial_t);
+extern long keyctl_get_security(key_serial_t keyid, char __user *buffer,
+				size_t buflen);
 
 
 /*
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
