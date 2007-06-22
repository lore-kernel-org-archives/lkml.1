Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbXFVWdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbXFVWdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbXFVWcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:32:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52464 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbXFVWcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:32:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
References: <200706221219.16243.yinghai.lu@sun.com>
	<20070622193124.GG5051@rhun.smartcity.com>
	<20070622213327.69663288@the-village.bc.nu>
	<m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
	<20070622231951.4d516215@the-village.bc.nu>
Date: Fri, 22 Jun 2007 16:32:21 -0600
In-Reply-To: <20070622231951.4d516215@the-village.bc.nu> (Alan Cox's message
	of "Fri, 22 Jun 2007 23:19:51 +0100")
Message-ID: <m1tzszaadm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> YH do you think you can look at simply reserving a portion of the iommu?
>> And having the kexec on panic kernel use the reserved portion?
>
> How about simply reserving all of it for the base kernel and using soft
> iommu for the panic kernel, its hardly high performance criticial at this
> point.

The original design came from thinking about systems where using the iommu
was mandatory.  I think we almost always reserve memory below 1G for the kexec
on panic kernel so it really shouldn't be an issue in that case.  Except
we need to pass an option to force not using the iommu.  I don't think
noiommu or swiotlb is going to make any real difference.

So I'm totally in favor of turning off features if we don't need them and we
don't take a tremendous performance hit.  (People get grumpy when writing
all of memory to disk takes completely unreasonable amounts of time).

Eric
