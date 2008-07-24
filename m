Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYGXMuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYGXMuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYGXMum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:50:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYGXMul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:50:41 -0400
Message-ID: <48887A72.1070209@redhat.com>
Date: Thu, 24 Jul 2008 08:49:54 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, ed.pollard@ibm.com, epollard@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <4887C2F7.6040506@redhat.com> <20080724074655.GM31439@8bytes.org> <488854DB.60307@redhat.com> <20080724193457S.fujita.tomonori@lab.ntt.co.jp> <20080724123755.GP31439@8bytes.org>
In-Reply-To: <20080724123755.GP31439@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But I think Prarit is right with this change. If the interface defines
> this behavior the IOMMU drivers have to implement it. I am just
> wondering that the problem never showed up before. The GART driver is a
> few years old now.
>
>   

Joerg -- there's an easy explanation for this.  This will only happen 
when a 32-bit device requests DMA memory and all memory below 4G is 
used.  Just doing a quick overview of a few systems, allocated DMA 
memory is usually less than 512M of the system memory so it is unlikely 
a system hits the 4G limit.

In addition to that most systems do not reserve all or most of the lower 
4G in the e820 maps.  Those that do are usually larger systems.

ie) The only reason we're seeing this now is because large memory 
footprint systems are coming online -- IMO ;)

P.

