Return-Path: <linux-kernel-owner+w=401wt.eu-S1030320AbXBZQxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320AbXBZQxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030327AbXBZQxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:53:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:6846 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030320AbXBZQxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:53:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nmBHIDx84IKDRq2dktBM66hiE4L8ioHZs0BA4Jhd4Hcd7R+FHqmAW7H3a6HvAs0kRD2DDm84k0Q1tRE2wS4Oy/TJ3cJGjAVXw11PuveyMF5H3F4YRuQt3OEQUo2/8wwEIFRWQ+3jEK7Jj9SEjFTy/oPbtIDki5E3N+GFkplcY7w=
Message-ID: <1681f2df0702260853u59ee7499nf2751034d5a2ec61@mail.gmail.com>
Date: Mon, 26 Feb 2007 11:53:40 -0500
From: "Chris Rohlf" <chris.rohlf@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: binfmt_elf.c EI_CLASS check patch
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

During some research of mine I realized most of my ELF analysis tools
break on ELF objects with an ELF header e_ident[EI_CLASS] not equal to
 ELFCLASS32 or ELFCLASS64. These objects still work fine because the
ELF  loader code does not check this value upon execution. So I wrote
a quick  patch to do it.

--- binfmt_elf.c.or1    2007-02-25 18:46:29.000000000 -0500
+++ binfmt_elf.c        2007-02-25 17:35:29.000000000 -0500
@@ -573,6 +573,10 @@ static int load_elf_binary(struct linux_
       if (!bprm->file->f_op||!bprm->file->f_op->mmap)
               goto out;

+        if (loc->elf_ex.e_ident[EI_CLASS] != ELFCLASS32 &&
+                loc->elf_ex.e_ident[EI_CLASS] != ELFCLASS64)
+                goto out;
+
       /* Now read in all of the header information */
       if (loc->elf_ex.e_phentsize != sizeof(struct elf_phdr))
               goto out;


I am not on the list, please CC replies to me.

Chris

-- 

http://em386.blogspot.com
