Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYGVWLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYGVWLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYGVWLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:11:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbYGVWLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:11:30 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] firewire: fw-ohci: TSB43AB22/A dualbuffer workaround
Date: Tue, 22 Jul 2008 18:11:26 -0400
User-Agent: KMail/1.9.9
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <tkrat.6a555e76ba524e73@s5r6.in-berlin.de>
In-Reply-To: <tkrat.6a555e76ba524e73@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221811.26653.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 12:41:10 pm Stefan Richter wrote:
> Isochronous reception in dualbuffer is reportedly broken with
> TI TSB43AB22A on x86-64.  Descriptor addresses above 2G have been
> determined as the trigger:
> https://bugzilla.redhat.com/show_bug.cgi?id=435550
>
> Two fixes are possible:
>   - pci_set_consistent_dma_mask(pdev, DMA_31BIT_MASK);
>     at least when IR descriptors are allocated, or
>   - simply don't use dualbuffer.
> This fix implements the latter workaround.
>
> But we keep using dualbuffer on x86-32 which won't give us highmen (and
> thus physical addresses outside the 31bit range) in coherent DMA memory
> allocations.  Right now we could for example also whitelist PPC32, but
> DMA mapping implementation details are expected to change there.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Still hoping we can get some confirmation of a chipset bug or a fix from TI 
for this controller, but in the interim, this seems to be the most reasonable 
route to go right now.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
