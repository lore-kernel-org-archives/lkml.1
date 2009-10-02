Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbZJBB7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbZJBB7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbZJBBco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:44 -0400
Received: from kroah.org ([198.145.64.141]:32960 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbZJBBcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:09 2009
Message-Id: <20091002012409.093839420@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Serge Hallyn <serue@us.ibm.com>, ecryptfs-devel@lists.launchpad.net,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [022/136] eCryptfs: Validate global auth tok keys
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=ecryptfs-validate-global-auth-tok-keys.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 3891959846709a19f76628e33478cd85edb0e79f upstream.

When searching through the global authentication tokens for a given key
signature, verify that a matching key has not been revoked and has not
expired.  This allows the `keyctl revoke` command to be properly used on
keys in use by eCryptfs.

Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: ecryptfs-devel@lists.launchpad.net
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/keystore.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -416,7 +416,9 @@ ecryptfs_find_global_auth_tok_for_sig(
 			    &mount_crypt_stat->global_auth_tok_list,
 			    mount_crypt_stat_list) {
 		if (memcmp(walker->sig, sig, ECRYPTFS_SIG_SIZE_HEX) == 0) {
-			(*global_auth_tok) = walker;
+			rc = key_validate(walker->global_auth_tok_key);
+			if (!rc)
+				(*global_auth_tok) = walker;
 			goto out;
 		}
 	}


