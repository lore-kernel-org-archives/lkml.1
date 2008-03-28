Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYC1TJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYC1TJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYC1TJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:09:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37654 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbYC1TJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:09:41 -0400
Date: Fri, 28 Mar 2008 20:09:39 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [Pull] Some documentation patches
In-Reply-To: <13387.1206728412@vena.lwn.net>
Message-ID: <alpine.LNX.1.10.0803282005440.27567@fbirervta.pbzchgretzou.qr>
References: <13387.1206728412@vena.lwn.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-03-28 19:20, Jonathan Corbet wrote:
>commit 9756ccfda31b4c4544aa010aacf71b6672d668e8
>Date:   Fri Mar 28 11:19:56 2008 -0600
>
>    Add the seq_file documentation

patch on top:

  - add const qualifiers
  - remove void* casts
  - use proper specifier (%Ld is not valid)

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index 92975ee..cc6cdb9 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -107,8 +107,8 @@ complete. Here's the example version:

  	static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
  	{
-	        loff_t *spos = (loff_t *) v;
-	        *pos = ++(*spos);
+	        loff_t *spos = v;
+	        *pos = ++*spos;
  	        return spos;
  	}

@@ -127,8 +127,8 @@ something goes wrong. The example module's show() function is:

  	static int ct_seq_show(struct seq_file *s, void *v)
  	{
-	        loff_t *spos = (loff_t *) v;
-	        seq_printf(s, "%Ld\n", *spos);
+	        loff_t *spos = v;
+	        seq_printf(s, "%lld\n", (long long)*spos);
  	        return 0;
  	}

@@ -136,7 +136,7 @@ We will look at seq_printf() in a moment. But first, the definition of the
  seq_file iterator is finished by creating a seq_operations structure with
  the four functions we have just defined:

-	static struct seq_operations ct_seq_ops = {
+	static const struct seq_operations ct_seq_ops = {
  	        .start = ct_seq_start,
  	        .next  = ct_seq_next,
  	        .stop  = ct_seq_stop,
@@ -204,7 +204,7 @@ line, as in the example module:
  	static int ct_open(struct inode *inode, struct file *file)
  	{
  		return seq_open(file, &ct_seq_ops);
-	};
+	}

  Here, the call to seq_open() takes the seq_operations structure we created
  before, and gets set up to iterate through the virtual file.
@@ -219,7 +219,7 @@ The other operations of interest - read(), llseek(), and release() - are
  all implemented by the seq_file code itself. So a virtual file's
  file_operations structure will look like:

-	static struct file_operations ct_file_ops = {
+	static const struct file_operations ct_file_ops = {
  	        .owner   = THIS_MODULE,
  	        .open    = ct_open,
  	        .read    = seq_read,
