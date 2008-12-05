Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYLEHCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYLEHCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYLEHC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:02:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:64733 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYLEHC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:02:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K1Q7kkamGqggP+efaRxo0PgaLDTrNpEFedb5MXhIVhFS8DBIVg1doYZYS+CJB9PNTa
         R+Kbd5BAJyvs368KVuaPyAwmRWhTFnth1+tOG/ELgSeRFKzT/ilizxZ5WqK5klsCnQnz
         Q5cX+NAPI7ix13vMqzBiJKGWv4M60kVAMzhGk=
Date: Fri, 5 Dec 2008 10:06:42 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: next-2008-12-04: vm.bio_inline_vecs
Message-ID: <20081205070642.GA31087@x200.localdomain>
References: <20081204200745.eff0ac87.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204200745.eff0ac87.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, merge into 4d539d965767b98582fa9b7b57f51dbc0ab54fc4
aka "bio: add experimental support for inlining a number of bio_vecs inside the bio"

kernel/sysctl.c:1233: error: 'bio_inline_vecs' undeclared here (not in a function)

--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1227,6 +1227,7 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_BLOCK
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "bio_inline_vecs",
@@ -1237,6 +1238,7 @@ static struct ctl_table vm_table[] = {
 		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
