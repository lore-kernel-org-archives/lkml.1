Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0CISHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:07:36 -0500
Received: from smtp124.mail.ukl.yahoo.com ([77.238.184.55]:20579 "HELO
	smtp124.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754899Ab0CISHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:07:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=NLqwLLvX0U2kdi1ZfzdcDETiqnYBjMR4d6lnTyFw89BnKQSeg4WqgWbdCsUzhYFImclzEH9pyIBrlGNsUMx8qjGnM+CgQKGlqCQFOpgODFC3srrO1JWgOoJDTvC9rf3CLHVPiFc3q2iyvNQE41O2FDtwjySg67TcG8ka44nALE4=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: VhczH8wVM1mI6RGEVaJDBFCiBwLd98eVaRS3OH61lLFWDSL41R.NXMjW8N9mjmudCDmXxBxPKLU.IbhBt1x3HWkQwScClo7VnjgYcne0DLqwoVH2xgcmyNlYwSaBKvnJm0dzor6Gxm66k91BjXuchVmcUNpztXlRMKSmAGvMIyBabviW0dd5HraVaLFH0ZP3sdqWfaYScyHKudqaC17Rpzd3hWERrWdC2Drrogj4juWC8IqMp4SfFcySPevzQc0VRPn8wGaN6izj1RXwn3lYOCwafKB17toWZVjPCllBBjJBcFI-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B968E5D.5060708@yahoo.es>
Date: Tue, 09 Mar 2010 19:07:25 +0100
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [LKML] [RFC PATCH v3 04/11] swiotlb: support	NOT_COHERENT_CACHE
 PowerPC platforms
References: <1267963912-984-1-git-send-email-albert_herranz@yahoo.es> <1267963912-984-5-git-send-email-albert_herranz@yahoo.es> <20100308165500.GB4568@phenom.dumpdata.com>
In-Reply-To: <20100308165500.GB4568@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> Hey Albert,
> 
> I've been doing some posting in this area to split the physical / bus
> address translation so that multiple platforms can utilize it. I was
> wondering if it makes sense to utilize some of those concepts (ie, extend it
> for DMA coherency) for your code:
> 
> https://lists.linux-foundation.org/pipermail/iommu/2010-February/002066.html
> 
> And here is the git tree that goes on top of those patches:
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git xen-swiotlb-0.5
> 

Hi Konrad,

Thanks for your comments.

In my case, I'd like to re-use as much code from swiotlb as possible.
Adding a few function calls at strategic spots (which are optimized out for cache coherent platforms) to maintain cache coherency is currently enough for me if that's acceptable.
A more general approach would involve making swiotlb_bounce() platform-dependent (or at least the actual code for copying the buffers), and re-implementing map_page, sync_single and map_sg at the platform DMA code again.

I've whipped through your patches. If I undestood them, you make available a kind of swiotlb "library" core on top of which you can build alternate swiotlb-based dma ops.
Wouldn't it be a good idea to split the "library" code from the default swiotlb dma ops?
A(n embedded) platform may just want the "library" code to implement its own dma ops, without having to pay for the extra default swiotlb dma ops implementation.

Thanks,
Albert

