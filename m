Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbXFWA01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbXFWA01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 20:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbXFWA0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 20:26:18 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51453 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbXFWA0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 20:26:17 -0400
Date: Fri, 22 Jun 2007 17:27:50 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
In-reply-to: <200706230214.02535.ak@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <467C6906.6020105@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=iso-8859-1
Content-transfer-encoding: 7BIT
References: <200706221219.16243.yinghai.lu@sun.com>
 <m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
 <20070622231951.4d516215@the-village.bc.nu> <200706230214.02535.ak@suse.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Saturday 23 June 2007 00:19:51 Alan Cox wrote:
> The kdump kernel should be normally all <4GB anyways. You won't
> need any IOMMU for its IO unless you O_DIRECT/sendfile out of /proc/kcore.
> Just don't do that (but I suspect it won't work anyways)
> 
> If it's not then swiotlb will also not work because it won't get 
> any memory <4GB.
> 
> But I doubt this was YH's problem - the panic kernel memory
> is always reserved and there shouldn't be any ongoing DMAs in this
> area anyways. And what happens outside the kdump kernel shouldn't matter.
> 
> I suspect he rather saw problems with non kdump kexec where we
> can just shut down the GART properly beforehand.

current I only test kexec only. So clean shut GART in first kernel will help.

where is hook for shutdown? add one in dma_ops?

YH
