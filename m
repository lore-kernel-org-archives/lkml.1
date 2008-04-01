Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbYDAPmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbYDAPmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYDAPmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:42:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:63944 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbYDAPma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:42:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=WzanT4lJoaUOf+efpTLoTQ0DxEU3MA9QVxEwJeREM7vOCF3UJpeuL9vbKQKYxH2YBcMW3pRwhcm99Dq6LzXYt8YPmeYkwp0QtEvs8XN14au7KJ4047BKFotNdcMJeI5kD5vsbJ+JVSVHv9qJf5MQ0dgmjH2UnzGTChSampI+TPg=
Date: Tue, 1 Apr 2008 19:41:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Markus Metzger <markus.t.metzger@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Debug Store - call kfree if only we really need it
Message-ID: <20080401154150.GA7654@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should call for kfree if only we really need it.
Though it's safe to call kfree with NULL pointer passed
in this code we've already tested the pointer and can
eliminate the call

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 ds.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/ds.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/ds.c	2008-03-30 15:05:50.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/ds.c	2008-04-01 19:20:20.000000000 +0400
@@ -220,11 +220,11 @@ int ds_allocate(void **dsp, size_t bts_s
 
 int ds_free(void **dsp)
 {
-	if (*dsp)
+	if (*dsp) {
 		kfree((void *)get_bts_buffer_base(*dsp));
-	kfree(*dsp);
-	*dsp = NULL;
-
+		kfree(*dsp);
+		*dsp = NULL;
+	}
 	return 0;
 }
 
