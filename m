Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbYCNQld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbYCNQld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYCNQlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:41:25 -0400
Received: from outbound-mail-02.bluehost.com ([69.89.21.12]:43453 "HELO
	outbound-mail-02.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754190AbYCNQlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:41:24 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs() interface
Date: Fri, 14 Mar 2008 09:40:45 -0700
User-Agent: KMail/1.9.9
Cc: Michael Ellerman <michael@ellerman.id.au>, akepner@sgi.com,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Tony Luck <tony.luck@intel.com>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Mark Nelson <mdnelson@au1.ibm.com>
References: <20080228032448.GS11012@sgi.com> <1205469029.7414.18.camel@concordia.ozlabs.ibm.com> <20080314052158.GG24794@colo.lackof.org>
In-Reply-To: <20080314052158.GG24794@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803140940.45843.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 13, 2008 10:21 pm Grant Grundler wrote:
> > What if something is writing to a device?
>
> aka MMIO writes. Not defined and in general unrelated. AFAIK, no
> version of PCI has ordering rules for traffic going in opposite
> directions. I'm 99% sure about this but haven't reviewed any
> PCI docs in about 2 years.

Yeah, afaik mmio traffic will be unaffected.  It's travelling in the other 
direction and subject to different ordering constraints.

> On a related note, I always think of MSI/MSI-X as DMA Writes.
> Michael's got me thinking we need to explicitly state that.
> In "normal" use, the device will not issue an MSI until after
> the "completion DMA write" has been issued and thus the MSI/MSI-X
> transactions are NOT subject to the ordering requirement...but
> that's not exactly true. We don't want the MSI to ever
> pass the "completion DMA write".
>
> Do we need to state the platform interconnect can NOT allow
> successive DMA writes to pass the ordered DMA writes?
> Or state MSI DMA writes are implied to be to an "ordered DMA region"?
> Both statements?

Yeah, I've always thought of MSIs the same way.  The platform really should 
ensure that MSIs have this barrier bit set (regular interrupts on Altix are 
actually DMAs as well, and have the barrier bit set), either these docs or 
the MSI docs should probably indicate as much.  That could be done as a 
separate patch though...

Jesse
