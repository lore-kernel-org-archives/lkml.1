Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYCDCCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYCDCCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYCDCBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:01:16 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:10568 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYCDCBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:01:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DM1uS87OE2eWoRtpb7g6T1oco0Ihg7eSJV7RWBu0yoRzxk3q0AHo4EWN6/oedHlH1vTl5d6C6YB3RP/gtGQV03qN1pCUmuAYhQWzr6e9EYBT1FKg4n5H5OXdjoaS6hGdxEfpg6HX/D8pUDpotk2mh+16/ZipDsL6jYSzk2jukR0=
Subject: [PATCH 07/13] cifs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
References: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 18:01:03 -0800
Message-Id: <1204596063.22933.59.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/cifs/cifs_dfs_ref.c |   18 +++++++++---------
 fs/cifs/cifsproto.h    |    4 ++--
 fs/cifs/dns_resolve.c  |    8 ++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 6ad4475..0be8359 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -74,7 +74,7 @@ static char *cifs_get_share_name(const char *node_name)
 	pSep = memchr(UNC+2, '\\', len-2);
 	if (!pSep) {
 		cERROR(1, ("%s: no server name end in node name: %s",
-			__FUNCTION__, node_name));
+			__func__, node_name));
 		kfree(UNC);
 		return NULL;
 	}
@@ -84,7 +84,7 @@ static char *cifs_get_share_name(const char *node_name)
 	pSep = memchr(UNC+(pSep-UNC), '\\', len-(pSep-UNC));
 	if (!pSep) {
 		cERROR(1, ("%s:2 cant find share name in node name: %s",
-			__FUNCTION__, node_name));
+			__func__, node_name));
 		kfree(UNC);
 		return NULL;
 	}
@@ -127,7 +127,7 @@ static char *compose_mount_options(const char *sb_mountdata,
 	rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
 	if (rc != 0) {
 		cERROR(1, ("%s: Failed to resolve server part of %s to IP",
-			  __FUNCTION__, *devname));
+			  __func__, *devname));
 		mountdata = ERR_PTR(rc);
 		goto compose_mount_options_out;
 	}
@@ -181,8 +181,8 @@ static char *compose_mount_options(const char *sb_mountdata,
 		}
 	}
 
-	/*cFYI(1,("%s: parent mountdata: %s", __FUNCTION__,sb_mountdata));*/
-	/*cFYI(1, ("%s: submount mountdata: %s", __FUNCTION__, mountdata ));*/
+	/*cFYI(1,("%s: parent mountdata: %s", __func__,sb_mountdata));*/
+	/*cFYI(1, ("%s: submount mountdata: %s", __func__, mountdata ));*/
 
 compose_mount_options_out:
 	kfree(srvIP);
@@ -302,7 +302,7 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 	int rc = 0;
 	struct vfsmount *mnt = ERR_PTR(-ENOENT);
 
-	cFYI(1, ("in %s", __FUNCTION__));
+	cFYI(1, ("in %s", __func__));
 	BUG_ON(IS_ROOT(dentry));
 
 	xid = GetXid();
@@ -336,7 +336,7 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 			len = strlen(referrals[i].node_name);
 			if (len < 2) {
 				cERROR(1, ("%s: Net Address path too short: %s",
-					__FUNCTION__, referrals[i].node_name));
+					__func__, referrals[i].node_name));
 				rc = -EINVAL;
 				goto out_err;
 			}
@@ -344,7 +344,7 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 						nd->path.dentry,
 						referrals[i].node_name);
 			cFYI(1, ("%s: cifs_dfs_do_refmount:%s , mnt:%p",
-					 __FUNCTION__,
+					 __func__,
 					referrals[i].node_name, mnt));
 
 			/* complete mount procedure if we accured submount */
@@ -365,7 +365,7 @@ out:
 	FreeXid(xid);
 	free_dfs_info_array(referrals, num_referrals);
 	kfree(full_path);
-	cFYI(1, ("leaving %s" , __FUNCTION__));
+	cFYI(1, ("leaving %s" , __func__));
 	return ERR_PTR(rc);
 out_err:
 	path_put(&nd->path);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 2f09f56..00d8615 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -39,8 +39,8 @@ extern int smb_send(struct socket *, struct smb_hdr *,
 			unsigned int /* length */ , struct sockaddr *);
 extern unsigned int _GetXid(void);
 extern void _FreeXid(unsigned int);
-#define GetXid() (int)_GetXid(); cFYI(1,("CIFS VFS: in %s as Xid: %d with uid: %d",__FUNCTION__, xid,current->fsuid));
-#define FreeXid(curr_xid) {_FreeXid(curr_xid); cFYI(1,("CIFS VFS: leaving %s (xid = %d) rc = %d",__FUNCTION__,curr_xid,(int)rc));}
+#define GetXid() (int)_GetXid(); cFYI(1,("CIFS VFS: in %s as Xid: %d with uid: %d",__func__, xid,current->fsuid));
+#define FreeXid(curr_xid) {_FreeXid(curr_xid); cFYI(1,("CIFS VFS: leaving %s (xid = %d) rc = %d",__func__,curr_xid,(int)rc));}
 extern char *build_path_from_dentry(struct dentry *);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 /* extern void renew_parental_timestamps(struct dentry *direntry);*/
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index ef7f438..7cc86c4 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -77,14 +77,14 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 	/* search for server name delimiter */
 	len = strlen(unc);
 	if (len < 3) {
-		cFYI(1, ("%s: unc is too short: %s", __FUNCTION__, unc));
+		cFYI(1, ("%s: unc is too short: %s", __func__, unc));
 		return -EINVAL;
 	}
 	len -= 2;
 	name = memchr(unc+2, '\\', len);
 	if (!name) {
 		cFYI(1, ("%s: probably server name is whole unc: %s",
-					__FUNCTION__, unc));
+					__func__, unc));
 	} else {
 		len = (name - unc) - 2/* leading // */;
 	}
@@ -104,7 +104,7 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 		if (*ip_addr) {
 			memcpy(*ip_addr, rkey->payload.data, len);
 			(*ip_addr)[len] = '\0';
-			cFYI(1, ("%s: resolved: %s to %s", __FUNCTION__,
+			cFYI(1, ("%s: resolved: %s to %s", __func__,
 					rkey->description,
 					*ip_addr
 				));
@@ -114,7 +114,7 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 		}
 		key_put(rkey);
 	} else {
-		cERROR(1, ("%s: unable to resolve: %s", __FUNCTION__, name));
+		cERROR(1, ("%s: unable to resolve: %s", __func__, name));
 	}
 
 	kfree(name);
-- 
1.5.4.3.500.g83a2c


