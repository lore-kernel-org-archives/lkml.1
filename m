Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbYK0REe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbYK0REe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYK0RER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:04:17 -0500
Received: from outbound-mail-109.bluehost.com ([69.89.22.9]:37788 "HELO
	outbound-mail-109.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752815AbYK0REQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:04:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=FLaGpWZa0cSk0uv/GCkiVNQx2NoJ9eJv6pmOjxaJR1KQiMVnrTtmQ594YGqADmoB1Mq2oXQKZk26lA8La3lwz+4yXBO83Ehp3r3v6B5o61WnUkSZJJhbWotV3VJuD4ht;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: always define DECLARE_PCI_UNMAP* macros
Date: Thu, 27 Nov 2008 09:04:09 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Joerg Roedel <joerg.roedel@amd.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, stable@kernel.org
References: <1227210596-1196-1-git-send-email-joerg.roedel@amd.com> <20081127114525.GC29013@elte.hu>
In-Reply-To: <20081127114525.GC29013@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811270904.13730.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 27, 2008 3:45 am Ingo Molnar wrote:
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> > Currently these macros evaluate to a no-op except the kernel is
> > compiled with GART or Calgary support. But we also need these macros
> > when we have SWIOTLB, VT-d or AMD IOMMU in the kernel. Since we
> > always compile at least with SWIOTLB we can define these macros
> > always. This patch is also for stable backport for the same reason
> > the SWIOTLB default selection patch is.
> >
> > Cc: stable@kernel.org
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/include/asm/pci_64.h |   14 --------------
> >  1 files changed, 0 insertions(+), 14 deletions(-)
>
> applied to tip/x86/urgent (for v2.6.28), as this is a DMA mapping
> bugfix for IOMMUs. If the AMD IOMMU is turned on in the .config but
> CONFIG_GART_IOMMU is off (a rare but possible combo), we'd leak on
> unmap and crash the box quickly.
>
> Jesse, is that path of upstream merge fine with you?

Yeah, that's fine with me.  OTOH removing config options generally seems like 
a good idea too, so maybe this combination should just be disallowed.  Or is 
there a good reason for this type of config?

-- 
Jesse Barnes, Intel Open Source Technology Center

