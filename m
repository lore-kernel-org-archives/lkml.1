Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXBTHHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXBTHHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 02:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964811AbXBTHHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 02:07:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:60048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964810AbXBTHHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 02:07:19 -0500
Date: Mon, 19 Feb 2007 23:05:56 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org
Subject: Re: Linux 2.6.19.4
Message-ID: <20070220070556.GE11688@kroah.com>
References: <20070220070055.GB11688@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220070055.GB11688@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 976d24a..fa3a8f2 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 19
-EXTRAVERSION = .3
+EXTRAVERSION = .4
 NAME=Avast! A bilge rat!
 
 # *DOCUMENTATION*
diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index e3eca08..230895e 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -287,13 +287,20 @@ static int nfsaclsvc_release_getacl(struct svc_rqst *rqstp, __be32 *p,
 	return 1;
 }
 
-static int nfsaclsvc_release_fhandle(struct svc_rqst *rqstp, __be32 *p,
-		struct nfsd_fhandle *resp)
+static int nfsaclsvc_release_attrstat(struct svc_rqst *rqstp, __be32 *p,
+		struct nfsd_attrstat *resp)
 {
 	fh_put(&resp->fh);
 	return 1;
 }
 
+static int nfsaclsvc_release_access(struct svc_rqst *rqstp, __be32 *p,
+               struct nfsd3_accessres *resp)
+{
+       fh_put(&resp->fh);
+       return 1;
+}
+
 #define nfsaclsvc_decode_voidargs	NULL
 #define nfsaclsvc_encode_voidres	NULL
 #define nfsaclsvc_release_void		NULL
@@ -322,9 +329,9 @@ struct nfsd3_voidargs { int dummy; };
 static struct svc_procedure		nfsd_acl_procedures2[] = {
   PROC(null,	void,		void,		void,	  RC_NOCACHE, ST),
   PROC(getacl,	getacl,		getacl,		getacl,	  RC_NOCACHE, ST+1+2*(1+ACL)),
-  PROC(setacl,	setacl,		attrstat,	fhandle,  RC_NOCACHE, ST+AT),
-  PROC(getattr, fhandle,	attrstat,	fhandle,  RC_NOCACHE, ST+AT),
-  PROC(access,	access,		access,		fhandle,  RC_NOCACHE, ST+AT+1),
+  PROC(setacl,	setacl,		attrstat,	attrstat, RC_NOCACHE, ST+AT),
+  PROC(getattr, fhandle,	attrstat,	attrstat, RC_NOCACHE, ST+AT),
+  PROC(access,	access,		access,		access,   RC_NOCACHE, ST+AT+1),
 };
 
 struct svc_version	nfsd_acl_version2 = {
