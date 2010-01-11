Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076Ab0AKWF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0AKWF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843Ab0AKWF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:05:28 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:49514 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab0AKWF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:05:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AfkwnumQ0HI/H3RdFqWIHVOlb6usBYgRYBEs+edlkdsDMDDKNcGThYBBE5QWFj2JCf
         UasLCP/dB7bCAOVOJaUdXnO8bV9ZIV7wdELHgvAevYovdM0uCMQpatcB93iQtEijz0oq
         4hO2Gkv6e3OsCxuNdifffcSK1ujCTuSBpSqIc=
Message-ID: <4B4BA1A4.9050800@gmail.com>
Date: Mon, 11 Jan 2010 23:09:40 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: Steve French <sfrench@samba.org>, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [PATCH] cifs: remove redundant test in cifs_lookup() and 	cifs_do_rename()
References: <4B48D95D.5000106@gmail.com> <524f69651001111353u512e9b80s46b26714e27b5130@mail.gmail.com>
In-Reply-To: <524f69651001111353u512e9b80s46b26714e27b5130@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rc != -EOPNOTSUPP is true as well if rc is -EINVAL.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
> At first glance this looks like a typo (probably not a serious one, but
> worth fixing)
> 
> -                       else if ((rc == -EINVAL) || (rc != -EOPNOTSUPP))
> 
> looks like it should be:
> 
> +                       else if ((rc == -EINVAL) || (rc == -EOPNOTSUPP))

> -- 
> Thanks,
> 
> Steve

Yes, according to the comment it appears you're right.

Thanks

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 6ccf726..33a7427 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -690,7 +690,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 			 */
 			if ((rc == 0) || (rc == -ENOENT))
 				posix_open = true;
-			else if ((rc == -EINVAL) || (rc != -EOPNOTSUPP))
+			else if ((rc == -EINVAL) || (rc == -EOPNOTSUPP))
 				pTcon->broken_posix_open = true;
 		}
 		if (!posix_open)
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index cf18ee7..aec2928 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1264,7 +1264,7 @@ cifs_do_rename(int xid, struct dentry *from_dentry, const char *fromPath,
 	 * source Note that cross directory moves do not work with
 	 * rename by filehandle to various Windows servers.
 	 */
-	if (rc == 0 || rc != -ETXTBSY)
+	if (rc != -ETXTBSY)
 		return rc;
 
 	/* open the file to be renamed -- we need DELETE perms */

