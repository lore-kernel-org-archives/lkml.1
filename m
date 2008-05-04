Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYEDO01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYEDO01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYEDO0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:26:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:40705 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbYEDO0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=gxIDnTnS3UnmDygLwcxiMRplPENJXdpaeoDTt1h+kV9+QIx4oeIIrF54AnWQ9r/AlxHqH/7j0wPXgcGa6KhA5Qn2/ofEd7v8EeaqwHjo6uK4PqezqgtXiqPQ4woZhalkmBtULvN5TzkHP18/XAsmYQ3+hHkCgylrEQ4PJubYutM=
Date: Sun, 4 May 2008 22:30:11 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Eric Youngdale <ericy@cais.com>, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] fs/binfmt_elf.c: fix a wrong free
Message-ID: <20080504143011.GB3720@hack>
References: <20080503124610.GA3986@hack> <Pine.LNX.4.64.0805031625150.20470@sbz-30.cs.Helsinki.FI> <20080503143942.GE3986@hack> <481D9247.4010804@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481D9247.4010804@cs.helsinki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 01:39:03PM +0300, Pekka Enberg wrote:

> Looks good although 'ret' is usually reserved for the variable that 
> contains the return value so you might want to consider using the more 
> idiomatic 'out' as the label name.
>

Thanks. Done.

---
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f6d5a9d..357b503 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1900,7 +1900,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	/* alloc memory for large data structures: too large to be on stack */
 	elf = kmalloc(sizeof(*elf), GFP_KERNEL);
 	if (!elf)
-		goto cleanup;
+		goto out;
 	
 	segs = current->mm->map_count;
 #ifdef ELF_CORE_EXTRA_PHDRS
@@ -2034,8 +2034,9 @@ end_coredump:
 	set_fs(fs);
 
 cleanup:
-	kfree(elf);
 	free_note_info(&info);
+	kfree(elf);
+out:
 	return has_dumped;
 }
 
