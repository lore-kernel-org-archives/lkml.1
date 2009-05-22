Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbZEVLnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbZEVLnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbZEVLnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:43:24 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32077 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbZEVLnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:43:23 -0400
X-IronPort-AV: E=Sophos;i="4.41,233,1241409600"; 
   d="scan'208";a="52205408"
Subject: Re: swiotlb: remove __weak hooks in favour of
	architecture-specific functions
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "jeremy@goop.org" <jeremy@goop.org>,
       "beckyb@kernel.crashing.org" <beckyb@kernel.crashing.org>,
       "okir@suse.de" <okir@suse.de>, "mingo@elte.hu" <mingo@elte.hu>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "xendevel@lists.xensource.com" <xendevel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090522201325I.fujita.tomonori@lab.ntt.co.jp>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
	 <1242922528-5982-1-git-send-email-ian.campbell@citrix.com>
	 <20090522201325I.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 22 May 2009 12:43:16 +0100
Message-ID: <1242992596.22654.273.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 07:13 -0400, FUJITA Tomonori wrote:
> On Thu, 21 May 2009 17:15:21 +0100
> Ian Campbell <ian.campbell@citrix.com> wrote:
> Please go with the following way (that I posted yesterday):
> 
> http://marc.info/?l=xen-devel&m=124292666214380&w=2
> 
> 
> Export the core feature of swiotlb, managing iotlb buffer and
> implement the Xen mapping functions.

I feel that should be a last resort, before we go down that path we
should try and find a way for us to use the generic code in a clean way
which makes everyone happy.

We have had several attempts at this and admittedly have not yet come up
with something that satisfies everyone but I don't really think we have
gotten to the point of admitting defeat and just duplicating the code.

I think the proposal to use a dma_map_range-like function which I sent a
few minutes ago I think gets us closer to something which satisfies
everyone's requirements, including yours for a clean abstraction.

>  With that approach, there is not
> much code duplication and there is no need for ugly hooks for dom0;
> the phys/bus address conversion and address checking.

The phys/bus address conversion is also needed for powerpc.

I think the two address checking functions can be collapsed into a
single one which satisfies the needs of both Xen and powerpc.

What dom0 specific "ugly" hooks does that leave? The alloc one? I've
discussed that in another mail.

Ian.

