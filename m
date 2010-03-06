Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab0CFLCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:02:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:24860 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0CFLCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:02:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=bEmvPjVZqsMiq/+UT2EMoLSf8sOEB7CFz3kpgytX2VooK01HegmsQ6apsZiHqZEE3P
         4dEMSsddPU3L6k7lmUFMunzsmr2LaVSv7YNDqfMigs1GkSEm4pUF1m1blLpXhYZ3E6np
         6AqL7Nf9udu7Pfq6BPY854yjn9j7IqlLRohQs=
Date: Sat, 6 Mar 2010 13:59:34 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Banks <gnb@melbourne.sgi.com>,
       =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] dynamic_debug: small clean up in ddebug_proc_write()
Message-ID: <20100306105934.GA4958@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jason Baron <jbaron@redhat.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Banks <gnb@melbourne.sgi.com>,
	=?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the doesn't change behavior at all.  In the original code, if nwords
was zero then ddebug_parse_query() would return -EINVAL, now we just do 
it earlier.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index f935029..4482f9d 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -455,7 +455,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 			__func__, (int)len);
 
 	nwords = ddebug_tokenize(tmpbuf, words, MAXWORDS);
-	if (nwords < 0)
+	if (nwords <= 0)
 		return -EINVAL;
 	if (ddebug_parse_query(words, nwords-1, &query))
 		return -EINVAL;
