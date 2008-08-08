Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbYHHWLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbYHHWLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762468AbYHHV4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:56:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762771AbYHHV4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:56:46 -0400
Message-ID: <489CC0DD.5010402@zytor.com>
Date: Fri, 08 Aug 2008 14:55:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] PNP: make the resource type an unsigned long
References: <489BEA31.3040101@keyaccess.nl>
In-Reply-To: <489BEA31.3040101@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Hi Bjorn.
> 
> Andrew earlier commented that pci_resourec_flags() returns an unsigned 
> long. Had this hanging around a local branch. Useful?
> 

-int pnp_resource_type(struct resource *res)
+unsigned long pnp_resource_type(struct resource *res)
  {
  	return res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
  			     IORESOURCE_IRQ | IORESOURCE_DMA);
  }

Seems a bit pointless ... either one of those flags is >= 32 bits, in 
which case we need u64, or it's not, in which case there is no reason to 
burden the output with bits we don't need.

	-hpa
