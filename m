Return-Path: <linux-kernel-owner+w=401wt.eu-S1764553AbYECKg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764553AbYECKg6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760554AbYECKgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:36:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:1557 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760484AbYECKgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rYOj7PM1PQRzMFcp679/EeL4kDYFsCuFWoopzndQGjJu9iX6qcO89TjDizI88/nsKquAnpnQUORyYaLL8/bX9TP7+2SiAL074eXSeq54fZdkQ6acel5XMSAuZw+s4GNpFTSPtHMElImjmgc0TDguZeVkNibG5FKZ0/tuWgcZr2o=
Date: Sat, 3 May 2008 14:35:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       ralf@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] MIPS: ELF handling - use SELFMAG instead of
	numeric constant
Message-ID: <20080503103558.GB6844@cvg>
References: <20080503101800.417039810@gmail.com>> <481c3f59.0407560a.2d49.ffffbf04@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481c3f59.0407560a.2d49.ffffbf04@mx.google.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sat, May 03, 2008 at 02:18:04PM +0400]
| Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| ---
| 
| Index: linux-2.6.git/arch/mips/kernel/vpe.c
| ===================================================================
| --- linux-2.6.git.orig/arch/mips/kernel/vpe.c	2008-04-15 23:01:26.000000000 +0400
| +++ linux-2.6.git/arch/mips/kernel/vpe.c	2008-05-02 21:40:57.000000000 +0400
| @@ -840,7 +840,7 @@ static int vpe_elfload(struct vpe * v)
|  
|  	/* Sanity checks against insmoding binaries or wrong arch,
|  	   weird elf version */
| -	if (memcmp(hdr->e_ident, ELFMAG, 4) != 0
| +	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
|  	    || (hdr->e_type != ET_REL && hdr->e_type != ET_EXEC)
|  	    || !elf_check_arch(hdr)
|  	    || hdr->e_shentsize != sizeof(*sechdrs)) {
| 
| -- 
| 
oops, MIPS was not refreshed by whole. This is a fix.
---

From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: MIPS: ELF handling - use SELFMAG instead of numeric constant

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/mips/kernel/vpe.c
===================================================================
--- linux-2.6.git.orig/arch/mips/kernel/vpe.c	2008-04-15 23:01:26.000000000 +0400
+++ linux-2.6.git/arch/mips/kernel/vpe.c	2008-05-03 14:28:47.000000000 +0400
@@ -840,7 +840,7 @@ static int vpe_elfload(struct vpe * v)
 
 	/* Sanity checks against insmoding binaries or wrong arch,
 	   weird elf version */
-	if (memcmp(hdr->e_ident, ELFMAG, 4) != 0
+	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
 	    || (hdr->e_type != ET_REL && hdr->e_type != ET_EXEC)
 	    || !elf_check_arch(hdr)
 	    || hdr->e_shentsize != sizeof(*sechdrs)) {
@@ -1107,7 +1107,7 @@ static int vpe_release(struct inode *ino
 		return -ENODEV;
 
 	hdr = (Elf_Ehdr *) v->pbuffer;
-	if (memcmp(hdr->e_ident, ELFMAG, 4) == 0) {
+	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) == 0) {
 		if (vpe_elfload(v) >= 0) {
 			vpe_run(v);
 		} else {
