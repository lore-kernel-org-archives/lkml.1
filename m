Return-Path: <linux-kernel-owner+w=401wt.eu-S1761021AbYDPRsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021AbYDPRsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYDPRr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:47:59 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:64271 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYDPRr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:47:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=WYPnlTdNr0wfXESPN4uLMZvwamHIlejSDjEnb2FsVh0hTqij+wdJPm9U3X6e4rGieiczoSGJYgjTvmAGOO/Sg2gMlN9b52flQwgLIXRKPSPGgnqxn6AE2LQcBoz11R3leO5O8tqYB+2vW5PS4wSQ5C+VZj1/hYW5GK28riSGr4c=
References: <20080416174421.442716301@gmail.com>>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 21:44:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/3] CAPIFS: fix memory leak on remount
Content-Disposition: inline; filename=capi-memory-leak
Message-ID: <48063bc9.2234440a.747d.09eb@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

capifs_remount may reach 'return' statement
without freeing of memory allocated by kstrdup call

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Index: linux-2.6.git/drivers/isdn/capi/capifs.c
===================================================================
--- linux-2.6.git.orig/drivers/isdn/capi/capifs.c	2008-04-16 20:14:46.000000000 +0400
+++ linux-2.6.git/drivers/isdn/capi/capifs.c	2008-04-16 20:16:58.000000000 +0400
@@ -69,6 +69,7 @@ static int capifs_remount(struct super_b
 		} else if (sscanf(this_char, "mode=%o%c", &n, &dummy) == 1)
 			mode = n & ~S_IFMT;
 		else {
+			kfree(new_opt);
 			printk("capifs: called with bogus options\n");
 			return -EINVAL;
 		}

-- 
