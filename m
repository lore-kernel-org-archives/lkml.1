Return-Path: <linux-kernel-owner+w=401wt.eu-S1031541AbXD1Qfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031541AbXD1Qfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031542AbXD1Qfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:35:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:7234 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031541AbXD1Qff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Tj6CuNooHgoQapRQOtTHTK4eQXKw3xF7JdNvGMY866QBitYaruAPQ+YurX7jDIrfEXsML2v7elTW78wt7xmLSnPuwBiwDsB4gHV0CO0Ef05UkAgiXBkBvSIXJNsJSJUbRXQgCiYDPQtjXSPDZzuMSVEGaDE/SaFLHQvLFsY+5NA=
Date: Sun, 29 Apr 2007 01:29:48 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: William Lee Irwin III <wli@holomorphy.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] hugetlbfs: add NULL check in hugetlb_zero_setup()
Message-ID: <20070428162948.GA9717@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	William Lee Irwin III <wli@holomorphy.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070428071923.GB9545@APFDCB5C> <20070428145039.GX19966@holomorphy.com> <20070428161856.GA9662@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428161856.GA9662@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If hugetlbfs module_init() fails, hugetlbfs_vfsmount
is not initialized and shmget() with SHM_HUGETLB flag will
cause NULL pointer dereference.

Cc: William Irwin <wli@holomorphy.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Index: 2.6-mm/fs/hugetlbfs/inode.c
===================================================================
--- 2.6-mm.orig/fs/hugetlbfs/inode.c
+++ 2.6-mm/fs/hugetlbfs/inode.c
@@ -740,6 +740,9 @@ struct file *hugetlb_zero_setup(size_t s
 	char buf[16];
 	static atomic_t counter;
 
+	if (!hugetlbfs_vfsmount)
+		return ERR_PTR(-ENOENT);
+
 	if (!can_do_hugetlb_shm())
 		return ERR_PTR(-EPERM);
 
