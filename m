Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYCDCDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYCDCDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbYCDCBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:01:18 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:13312 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYCDCBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:01:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GXep3yFF8Sjd4Bfchi3Qb+p2bimiBR+y2cR+AQUCq1kWLGy+UNIqH98jEkRFCs2u9cqC8jY8Q1AHNgj0tbLM2ER1Y2dv/Umtm6SKmKLtcqRsnNjlu8TBw7gWbAaGxMl3ZpMoI4RSnEVt8K439E36ymg5CNd1CpgIiefQN44pFxs=
Subject: [PATCH 06/13] ecryptfs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mike Halcrow <mhalcrow@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
References: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 18:01:02 -0800
Message-Id: <1204596062.22933.58.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ecryptfs/crypto.c          |   32 ++++++++++++++++----------------
 fs/ecryptfs/ecryptfs_kernel.h |    2 +-
 fs/ecryptfs/inode.c           |    2 +-
 fs/ecryptfs/main.c            |    2 +-
 fs/ecryptfs/mmap.c            |   10 +++++-----
 fs/ecryptfs/read_write.c      |   16 ++++++++--------
 6 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index a066e10..7591663 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -119,21 +119,21 @@ static int ecryptfs_calculate_md5(char *dst,
 	if (rc) {
 		printk(KERN_ERR
 		       "%s: Error initializing crypto hash; rc = [%d]\n",
-		       __FUNCTION__, rc);
+		       __func__, rc);
 		goto out;
 	}
 	rc = crypto_hash_update(&desc, &sg, len);
 	if (rc) {
 		printk(KERN_ERR
 		       "%s: Error updating crypto hash; rc = [%d]\n",
-		       __FUNCTION__, rc);
+		       __func__, rc);
 		goto out;
 	}
 	rc = crypto_hash_final(&desc, dst);
 	if (rc) {
 		printk(KERN_ERR
 		       "%s: Error finalizing crypto hash; rc = [%d]\n",
-		       __FUNCTION__, rc);
+		       __func__, rc);
 		goto out;
 	}
 out:
@@ -437,7 +437,7 @@ static int ecryptfs_encrypt_extent(struct page *enc_extent_page,
 	if (rc < 0) {
 		printk(KERN_ERR "%s: Error attempting to encrypt page with "
 		       "page->index = [%ld], extent_offset = [%ld]; "
-		       "rc = [%d]\n", __FUNCTION__, page->index, extent_offset,
+		       "rc = [%d]\n", __func__, page->index, extent_offset,
 		       rc);
 		goto out;
 	}
@@ -487,7 +487,7 @@ int ecryptfs_encrypt_page(struct page *page)
 						       0, PAGE_CACHE_SIZE);
 		if (rc)
 			printk(KERN_ERR "%s: Error attempting to copy "
-			       "page at index [%ld]\n", __FUNCTION__,
+			       "page at index [%ld]\n", __func__,
 			       page->index);
 		goto out;
 	}
@@ -508,7 +508,7 @@ int ecryptfs_encrypt_page(struct page *page)
 					     extent_offset);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting extent; "
-			       "rc = [%d]\n", __FUNCTION__, rc);
+			       "rc = [%d]\n", __func__, rc);
 			goto out;
 		}
 		ecryptfs_lower_offset_for_extent(
@@ -569,7 +569,7 @@ static int ecryptfs_decrypt_extent(struct page *page,
 	if (rc < 0) {
 		printk(KERN_ERR "%s: Error attempting to decrypt to page with "
 		       "page->index = [%ld], extent_offset = [%ld]; "
-		       "rc = [%d]\n", __FUNCTION__, page->index, extent_offset,
+		       "rc = [%d]\n", __func__, page->index, extent_offset,
 		       rc);
 		goto out;
 	}
@@ -622,7 +622,7 @@ int ecryptfs_decrypt_page(struct page *page)
 						      ecryptfs_inode);
 		if (rc)
 			printk(KERN_ERR "%s: Error attempting to copy "
-			       "page at index [%ld]\n", __FUNCTION__,
+			       "page at index [%ld]\n", __func__,
 			       page->index);
 		goto out;
 	}
@@ -656,7 +656,7 @@ int ecryptfs_decrypt_page(struct page *page)
 					     extent_offset);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting extent; "
-			       "rc = [%d]\n", __FUNCTION__, rc);
+			       "rc = [%d]\n", __func__, rc);
 			goto out;
 		}
 	}
@@ -1215,7 +1215,7 @@ int ecryptfs_read_and_validate_header_region(char *data,
 				 ecryptfs_inode);
 	if (rc) {
 		printk(KERN_ERR "%s: Error reading header region; rc = [%d]\n",
-		       __FUNCTION__, rc);
+		       __func__, rc);
 		goto out;
 	}
 	if (!contains_ecryptfs_marker(data + ECRYPTFS_FILE_SIZE_BYTES)) {
@@ -1320,7 +1320,7 @@ ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
 				  0, crypt_stat->num_header_bytes_at_front);
 	if (rc)
 		printk(KERN_ERR "%s: Error attempting to write header "
-		       "information to lower file; rc = [%d]\n", __FUNCTION__,
+		       "information to lower file; rc = [%d]\n", __func__,
 		       rc);
 	return rc;
 }
@@ -1365,14 +1365,14 @@ int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry)
 		}
 	} else {
 		printk(KERN_WARNING "%s: Encrypted flag not set\n",
-		       __FUNCTION__);
+		       __func__);
 		rc = -EINVAL;
 		goto out;
 	}
 	/* Released in this function */
 	virt = kzalloc(crypt_stat->num_header_bytes_at_front, GFP_KERNEL);
 	if (!virt) {
-		printk(KERN_ERR "%s: Out of memory\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Out of memory\n", __func__);
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -1380,7 +1380,7 @@ int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry)
 					 ecryptfs_dentry);
 	if (unlikely(rc)) {
 		printk(KERN_ERR "%s: Error whilst writing headers; rc = [%d]\n",
-		       __FUNCTION__, rc);
+		       __func__, rc);
 		goto out_free;
 	}
 	if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
@@ -1391,7 +1391,7 @@ int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry)
 							 ecryptfs_dentry, virt);
 	if (rc) {
 		printk(KERN_ERR "%s: Error writing metadata out to lower file; "
-		       "rc = [%d]\n", __FUNCTION__, rc);
+		       "rc = [%d]\n", __func__, rc);
 		goto out_free;
 	}
 out_free:
@@ -1585,7 +1585,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 	if (!page_virt) {
 		rc = -ENOMEM;
 		printk(KERN_ERR "%s: Unable to allocate page_virt\n",
-		       __FUNCTION__);
+		       __func__);
 		goto out;
 	}
 	rc = ecryptfs_read_lower(page_virt, 0, crypt_stat->extent_size,
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 5007f78..342e8d3 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -500,7 +500,7 @@ ecryptfs_set_dentry_lower_mnt(struct dentry *dentry, struct vfsmount *lower_mnt)
 }
 
 #define ecryptfs_printk(type, fmt, arg...) \
-        __ecryptfs_printk(type "%s: " fmt, __FUNCTION__, ## arg);
+        __ecryptfs_printk(type "%s: " fmt, __func__, ## arg);
 void __ecryptfs_printk(const char *fmt, ...);
 
 extern const struct file_operations ecryptfs_main_fops;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index e238611..a7d5d7d 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -121,7 +121,7 @@ ecryptfs_do_create(struct inode *directory_inode,
 					     ecryptfs_dentry, mode, nd);
 	if (rc) {
 		printk(KERN_ERR "%s: Failure to create dentry in lower fs; "
-		       "rc = [%d]\n", __FUNCTION__, rc);
+		       "rc = [%d]\n", __func__, rc);
 		goto out_lock;
 	}
 	rc = ecryptfs_interpose(lower_dentry, ecryptfs_dentry,
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index d25ac95..d603631 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -219,7 +219,7 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
 	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to initialize the "
 		       "persistent file for the dentry with name [%s]; "
-		       "rc = [%d]\n", __FUNCTION__, dentry->d_name.name, rc);
+		       "rc = [%d]\n", __func__, dentry->d_name.name, rc);
 		goto out;
 	}
 out:
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index dc74b18..7f6267b 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -153,7 +153,7 @@ ecryptfs_copy_up_encrypted_with_header(struct page *page,
 			flush_dcache_page(page);
 			if (rc) {
 				printk(KERN_ERR "%s: Error reading xattr "
-				       "region; rc = [%d]\n", __FUNCTION__, rc);
+				       "region; rc = [%d]\n", __func__, rc);
 				goto out;
 			}
 		} else {
@@ -169,7 +169,7 @@ ecryptfs_copy_up_encrypted_with_header(struct page *page,
 			if (rc) {
 				printk(KERN_ERR "%s: Error attempting to read "
 				       "extent at offset [%lld] in the lower "
-				       "file; rc = [%d]\n", __FUNCTION__,
+				       "file; rc = [%d]\n", __func__,
 				       lower_offset, rc);
 				goto out;
 			}
@@ -212,7 +212,7 @@ static int ecryptfs_readpage(struct file *file, struct page *page)
 				       "the encrypted content from the lower "
 				       "file whilst inserting the metadata "
 				       "from the xattr into the header; rc = "
-				       "[%d]\n", __FUNCTION__, rc);
+				       "[%d]\n", __func__, rc);
 				goto out;
 			}
 
@@ -276,7 +276,7 @@ static int ecryptfs_prepare_write(struct file *file, struct page *page,
 						      page->mapping->host);
 		if (rc) {
 			printk(KERN_ERR "%s: Error attemping to read lower "
-			       "page segment; rc = [%d]\n", __FUNCTION__, rc);
+			       "page segment; rc = [%d]\n", __func__, rc);
 			ClearPageUptodate(page);
 			goto out;
 		} else
@@ -339,7 +339,7 @@ static int ecryptfs_write_inode_size_to_header(struct inode *ecryptfs_inode)
 	kfree(file_size_virt);
 	if (rc)
 		printk(KERN_ERR "%s: Error writing file size to header; "
-		       "rc = [%d]\n", __FUNCTION__, rc);
+		       "rc = [%d]\n", __func__, rc);
 out:
 	return rc;
 }
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index 0c49286..ebf5515 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -55,7 +55,7 @@ int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 	set_fs(fs_save);
 	if (octets_written < 0) {
 		printk(KERN_ERR "%s: octets_written = [%td]; "
-		       "expected [%td]\n", __FUNCTION__, octets_written, size);
+		       "expected [%td]\n", __func__, octets_written, size);
 		rc = -EINVAL;
 	}
 	mutex_unlock(&inode_info->lower_file_mutex);
@@ -153,7 +153,7 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 			rc = PTR_ERR(ecryptfs_page);
 			printk(KERN_ERR "%s: Error getting page at "
 			       "index [%ld] from eCryptfs inode "
-			       "mapping; rc = [%d]\n", __FUNCTION__,
+			       "mapping; rc = [%d]\n", __func__,
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
@@ -165,7 +165,7 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 			if (rc) {
 				printk(KERN_ERR "%s: Error decrypting "
 				       "page; rc = [%d]\n",
-				       __FUNCTION__, rc);
+				       __func__, rc);
 				ClearPageUptodate(ecryptfs_page);
 				page_cache_release(ecryptfs_page);
 				goto out;
@@ -202,7 +202,7 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 		page_cache_release(ecryptfs_page);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting "
-			       "page; rc = [%d]\n", __FUNCTION__, rc);
+			       "page; rc = [%d]\n", __func__, rc);
 			goto out;
 		}
 		pos += num_bytes;
@@ -254,7 +254,7 @@ int ecryptfs_read_lower(char *data, loff_t offset, size_t size,
 	set_fs(fs_save);
 	if (octets_read < 0) {
 		printk(KERN_ERR "%s: octets_read = [%td]; "
-		       "expected [%td]\n", __FUNCTION__, octets_read, size);
+		       "expected [%td]\n", __func__, octets_read, size);
 		rc = -EINVAL;
 	}
 	mutex_unlock(&inode_info->lower_file_mutex);
@@ -327,7 +327,7 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 		printk(KERN_ERR "%s: Attempt to read data past the end of the "
 			"file; offset = [%lld]; size = [%td]; "
 		       "ecryptfs_file_size = [%lld]\n",
-		       __FUNCTION__, offset, size, ecryptfs_file_size);
+		       __func__, offset, size, ecryptfs_file_size);
 		goto out;
 	}
 	pos = offset;
@@ -345,14 +345,14 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 			rc = PTR_ERR(ecryptfs_page);
 			printk(KERN_ERR "%s: Error getting page at "
 			       "index [%ld] from eCryptfs inode "
-			       "mapping; rc = [%d]\n", __FUNCTION__,
+			       "mapping; rc = [%d]\n", __func__,
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
 		rc = ecryptfs_decrypt_page(ecryptfs_page);
 		if (rc) {
 			printk(KERN_ERR "%s: Error decrypting "
-			       "page; rc = [%d]\n", __FUNCTION__, rc);
+			       "page; rc = [%d]\n", __func__, rc);
 			ClearPageUptodate(ecryptfs_page);
 			page_cache_release(ecryptfs_page);
 			goto out;
-- 
1.5.4.3.500.g83a2c


