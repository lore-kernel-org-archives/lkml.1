Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbZBEMrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbZBEMrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 07:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZBEMrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 07:47:35 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:52537 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586AbZBEMrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 07:47:35 -0500
Message-ID: <498ADFE3.9020907@vmware.com>
Date: Thu, 05 Feb 2009 13:47:31 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thellstrom@vmware.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: 2.6.29 pat issue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The function in include/linux/mm.h:
is_linear_pfn_mapping()

doesn't seem valid to me.

In particular, we have VMAs to graphics devices in which vma->vm_pgoff 
is non-zero (Points to an offset in the drm device node), and the VMA is 
sparsely populated with pfns pointing to uncached discontigous RAM pages.

This causes the X86 PAT code to hit the optimized path when it 
shouldn't, and issue a warning.

Also a question about the philosofy behind this strict checking that all 
PTEs have the same caching attributes: I guess this is only to catch 
bugs in kernel drivers that don't get this right. At the same time, now 
that also user-space VMAs are checked this will probably have a 
significant performance impact. Shouldn't this checking really live 
behind a debug define?

Thanks,
Thomas



