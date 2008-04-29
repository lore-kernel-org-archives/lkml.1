Return-Path: <linux-kernel-owner+w=401wt.eu-S1762490AbYD2QuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762490AbYD2QuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYD2Qtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:49:52 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40340 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbYD2Qtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:49:50 -0400
Date: Tue, 29 Apr 2008 09:49:18 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: apw@shadowen.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: false negative in checpatch for asm/ vs. linux/
Message-ID: <20080429164918.GB24967@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.6.25-mm1-00017-g1feb4e5-dirty (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

I think the following:

#warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
                if ($tree && $rawline =~ m{^.\#\s*include\s*\<asm\/(.*)\.h\>}) {
                        my $checkfile = "$root/include/linux/$1.h";
                        if (-f $checkfile && $1 ne 'irq') {
                                WARN("Use #include <linux/$1.h> instead of <asm/$1.h>\n" .
                                        $herecurr);
                        }
                }

in checkpatch.pl can lead to false positives for asm/ includes from within
linux/ files? e.g., I have a patch which moves the asm/hugetlb.h #include up to
the top of include/linux/hugetlb.h, but I get:

[09:46:27]nacc@arkanoid:~/linux/views/linux-2.6-work$ git show HEAD | ./scripts/checkpatch.pl -
WARNING: Use #include <linux/hugetlb.h> instead of <asm/hugetlb.h>
#17: FILE: include/linux/hugetlb.h:8:
+#include <asm/hugetlb.h>

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
