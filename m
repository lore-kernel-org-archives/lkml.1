Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbZLEAl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbZLEAl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbZLEAl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:41:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:17611 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbZLEAl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:41:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UVz718aHKx/f+vE9mn6QGS232Fj4eoMnMrWivCJcXZ10W3NZmfIboFnjtmSYz9q/Xs
         MLIA4V1t/7pDRU5ny+kUgrWgSdrDotzmtydMcodvw4DV8d0pmKZvSvmaoYCjgjBtYEX7
         lgKYn9Sc2LT8bxPg75IINKVGKJDVcO9zjNe9Q=
Date: Sat, 5 Dec 2009 03:42:04 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] seq_file: use proc_create() in documentation
Message-ID: <20091205004204.GE16465@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using create_proc_entry() + ->proc_fops assignment is racy because
->proc_fops will be NULL for some time, use proc_create() to avoid race.
---

 Documentation/filesystems/seq_file.txt |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index 0d15ebc..a1e2e0d 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -248,9 +248,7 @@ code, that is done in the initialization code in the usual way:
 	{
 	        struct proc_dir_entry *entry;
 
-	        entry = create_proc_entry("sequence", 0, NULL);
-	        if (entry)
-	                entry->proc_fops = &ct_file_ops;
+	        proc_create("sequence", 0, NULL, &ct_file_ops);
 	        return 0;
 	}
 
