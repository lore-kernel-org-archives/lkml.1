Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbYEAKYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbYEAKYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 06:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYEAKYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 06:24:33 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3056 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYEAKYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 06:24:32 -0400
Date: Thu, 1 May 2008 11:24:31 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: false negative in checpatch for asm/ vs. linux/
Message-ID: <20080501102431.GC20317@shadowen.org>
References: <20080429164918.GB24967@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429164918.GB24967@us.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 09:49:18AM -0700, Nishanth Aravamudan wrote:
> Hi Andy,
> 
> I think the following:
> 
> #warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
>                 if ($tree && $rawline =~ m{^.\#\s*include\s*\<asm\/(.*)\.h\>}) {
>                         my $checkfile = "$root/include/linux/$1.h";
>                         if (-f $checkfile && $1 ne 'irq') {
>                                 WARN("Use #include <linux/$1.h> instead of <asm/$1.h>\n" .
>                                         $herecurr);
>                         }
>                 }
> 
> in checkpatch.pl can lead to false positives for asm/ includes from within
> linux/ files? e.g., I have a patch which moves the asm/hugetlb.h #include up to
> the top of include/linux/hugetlb.h, but I get:
> 
> [09:46:27]nacc@arkanoid:~/linux/views/linux-2.6-work$ git show HEAD | ./scripts/checkpatch.pl -
> WARNING: Use #include <linux/hugetlb.h> instead of <asm/hugetlb.h>
> #17: FILE: include/linux/hugetlb.h:8:
> +#include <asm/hugetlb.h>

Yes, clearly stupid and trivial to detect.  Will be sorted in the 0.19.

Thanks for the report.

-apw
