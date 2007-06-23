Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbXFWAOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbXFWAOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 20:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbXFWAOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 20:14:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:53013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbXFWAON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 20:14:13 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Date: Sat, 23 Jun 2007 02:14:01 +0200
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Yinghai Lu <Yinghai.Lu@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706221219.16243.yinghai.lu@sun.com> <m18xabbrp6.fsf@ebiederm.dsl.xmission.com> <20070622231951.4d516215@the-village.bc.nu>
In-Reply-To: <20070622231951.4d516215@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706230214.02535.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007 00:19:51 Alan Cox wrote:
> > YH do you think you can look at simply reserving a portion of the iommu?
> > And having the kexec on panic kernel use the reserved portion?
> 
> How about simply reserving all of it for the base kernel and using soft
> iommu for the panic kernel, its hardly high performance criticial at this
> point.

The kdump kernel should be normally all <4GB anyways. You won't
need any IOMMU for its IO unless you O_DIRECT/sendfile out of /proc/kcore.
Just don't do that (but I suspect it won't work anyways)

If it's not then swiotlb will also not work because it won't get 
any memory <4GB.

But I doubt this was YH's problem - the panic kernel memory
is always reserved and there shouldn't be any ongoing DMAs in this
area anyways. And what happens outside the kdump kernel shouldn't matter.

I suspect he rather saw problems with non kdump kexec where we
can just shut down the GART properly beforehand.

-Andi
