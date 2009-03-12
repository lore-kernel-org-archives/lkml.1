Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZCLUag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZCLUag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZCLUa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:30:27 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:52177 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbZCLUa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:30:26 -0400
From: Frans Pop <elendil@planet.nl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] VM, x86, PAT: Change implementation of is_linear_pfn_mapping
Date: Thu, 12 Mar 2009 21:30:21 +0100
User-Agent: KMail/1.9.9
Cc: "mingo@elte.hu" <mingo@elte.hu>,
       "thellstrom@vmware.com" <thellstrom@vmware.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>
References: <498B5ADE.3090602@vmware.com> <200903120645.44515.elendil@planet.nl> <20090312185918.GA22421@linux-os.sc.intel.com>
In-Reply-To: <20090312185918.GA22421@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903122130.23860.elendil@planet.nl>
X-OriginalArrivalTime: 12 Mar 2009 20:30:24.0553 (UTC) FILETIME=[5F6E9190:01C9A351]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Pallipadi, Venkatesh wrote:
> OK, Looking more at the code, I now understand how the patch from
> yday resulted in the oops you saw. Here goes my nth attempt at solving
> this problem. Can you please test this patch.

System has been running stable for almost an hour now with pat enabled, so 
it looks like the problem is solved.

FYI, with early .29 RCs I had the following when running VirtualBox:
kernel: WARNING: at arch/x86/mm/pat.c:620 reserve_pfn_range+0x5b/0x26d()

After be03d9e80220 (which probably fixed that) VirtualBox could no longer 
be loaded at all with pat enabled, but with this patch added VirtualBox 
runs perfectly again.

Thanks Venki.

> Use of vma->vm_pgoff to identify the pfnmaps that are fully
> mapped at mmap time is broken. vm_pgoff is set by generic mmap
> code even for cases where drivers are setting up the mappings
> at the fault time.
>
> The problem was originally reported here.
> http://marc.info/?l=linux-kernel&m=123383810628583&w=2
>
> Change is_linear_pfn_mapping logic to overload VM_INSERTPAGE
> flag along with VM_PFNMAP to mean full PFNMAP setup at mmap
> time.
>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha>@intel.com>

Tested-by: Frans Pop <elendil@planet.nl>
