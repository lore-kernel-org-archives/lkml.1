Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbYBDUN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbYBDUN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbYBDUNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:13:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:60329 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbYBDUNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:13:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WAxT+Gihz+IYFNBOjZT8/1jhzZMjrydyxxzW6y+2ttoihnUF3I5Yy6I10ugZRvojDvnarRcEnZT54vAbi0kcDunqGQTClJbqL9JjAkjqshO9U8o/NyG3tPjsU2xwkKccFNA5ng61bki7GB1jrQPqCx1fOX+UVmJOtS/lVsVZ0T4=
Message-ID: <6101e8c40802041213y4f3cb310qaff40052ed18d5df@mail.gmail.com>
Date: Mon, 4 Feb 2008 21:13:16 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: stable@kernel.org
Subject: {2.6.22.y} CVE-2007-6434
Cc: linux-kernel@vger.kernel.org, "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "Greg KH" <gregkh@suse.de>, "Willy Tarreau" <w@1wt.eu>,
       "Adrian Bunk" <bunk@kernel.org>, "Nick Piggin" <npiggin@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mainline: ecaf18c15aac8bb9bed7b7aa0e382fe252e275d5

--->8---
commit ecaf18c15aac8bb9bed7b7aa0e382fe252e275d5
Author: Eric Paris <eparis@redhat.com>
Date:   Tue Dec 4 23:45:31 2007 -0800

    VM/Security: add security hook to do_brk

    Given a specifically crafted binary do_brk() can be used to get low pages
    available in userspace virtual memory and can thus be used to circumvent
    the mmap_min_addr low memory protection.  Add security checks in do_brk().

    Signed-off-by: Eric Paris <eparis@redhat.com>
    Acked-by: Alan Cox <alan@redhat.com>
    Cc: Stephen Smalley <sds@tycho.nsa.gov>
    Cc: James Morris <jmorris@namei.org>
    Cc: Chris Wright <chrisw@sous-sol.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/mmap.c b/mm/mmap.c
index facc1a7..acfc13f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1934,6 +1934,10 @@ unsigned long do_brk(unsigned long addr, unsigned long le
        if (is_hugepage_only_range(mm, addr, len))
                return -EINVAL;

+       error = security_file_mmap(0, 0, 0, 0, addr, 1);
+       if (error)
+               return error;
+
        flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;

        error = arch_mmap_check(addr, len, flags);
---8<---
-- 
Thanks,
Oliver
