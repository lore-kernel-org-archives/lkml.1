Return-Path: <linux-kernel-owner+w=401wt.eu-S1759736AbXLRPvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736AbXLRPvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXLRPva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:51:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbXLRPv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:51:29 -0500
Message-ID: <4767EC73.2030507@redhat.com>
Date: Tue, 18 Dec 2007 09:51:15 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>
CC: mike@halcrow.us, Jarod Wilson <jwilson@redhat.com>
Subject: [PATCH] ecryptfs: fix string overflow on long cipher names
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing a cipher name > 32 chars on mount results in an overflow
when the cipher name is printed, because the last character
in the struct ecryptfs_key_tfm's cipher_name string was never 
zeroed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc3/fs/ecryptfs/crypto.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ecryptfs/crypto.c
+++ linux-2.6.24-rc3/fs/ecryptfs/crypto.c
@@ -1847,6 +1847,7 @@ ecryptfs_add_new_key_tfm(struct ecryptfs
 	mutex_init(&tmp_tfm->key_tfm_mutex);
 	strncpy(tmp_tfm->cipher_name, cipher_name,
 		ECRYPTFS_MAX_CIPHER_NAME_SIZE);
+	tmp_tfm->cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE] = '\0';
 	tmp_tfm->key_size = key_size;
 	rc = ecryptfs_process_key_cipher(&tmp_tfm->key_tfm,
 					 tmp_tfm->cipher_name,



