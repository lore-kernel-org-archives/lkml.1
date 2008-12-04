Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYLDGfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYLDGfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbYLDGfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:35:09 -0500
Received: from tundra.namei.org ([65.99.196.166]:49916 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbYLDGfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:35:08 -0500
Date: Thu, 4 Dec 2008 17:33:39 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: linux-kernel@vger.kernel.org
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Howells <dhowells@redhat.com>,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Conflict resolved in the security-testing tree
Message-ID: <alpine.LRH.1.10.0812041731280.6279@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I resolved a conflict between the new creds API and the nfs4 server code 
in 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

per the patch below.  Please check.


diff --cc fs/nfsd/nfs4recover.c
index 9371ea1,b79ec93..0000000
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@@ -230,12 -224,10 +230,13 @@@ nfsd4_list_rec_dir(struct dentry *dir, 
  	if (!rec_dir_init)
  		return 0;
  
 -	nfs4_save_user(&uid, &gid);
 +	status = nfs4_save_creds(&original_cred);
 +	if (status < 0)
 +		return status;
+ 	INIT_LIST_HEAD(dentries);
  
 -	filp = dentry_open(dget(dir), mntget(rec_dir.mnt), O_RDONLY);
 +	filp = dentry_open(dget(dir), mntget(rec_dir.mnt), O_RDONLY,
 +			   current_cred());
  	status = PTR_ERR(filp);
  	if (IS_ERR(filp))
  		goto out;


-- 
James Morris
<jmorris@namei.org>
