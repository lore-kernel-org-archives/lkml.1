Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbXDWJcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbXDWJcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 05:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXDWJcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 05:32:39 -0400
Received: from mail.suse.de ([195.135.220.2]:48517 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbXDWJci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 05:32:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Joachim Deguara" <joachim.deguara@amd.com>
Subject: Re: [PATCH] x86_64: make GART PTEs uncacheable
Date: Mon, 23 Apr 2007 11:32:30 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, "Langsdorf, Mark" <mark.langsdorf@amd.com>
References: <200704231114.10327.joachim.deguara@amd.com>
In-Reply-To: <200704231114.10327.joachim.deguara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704231132.30736.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 11:14:10 Joachim Deguara wrote:
> This patches fixes the silent data corruption problems being seen using the 
> GART iommu where 4kB of data where incorrect (seen mostly on Nvidia CK804 
> systems).

Performance numbers? How much slower does this make this? Is it still faster
than swiotlb?

Also this will always split up the direct memory mapping of the kernel,
so you'll lose more TLB entries even for other data. 

> This fix, to mark the memory regin the GART PTEs reside on as  
> uncacheable, also brings the code in line with the AGP specification.

Where in the AGP specification? I can't find any such requirement
in AGPv3

-Andi
 
