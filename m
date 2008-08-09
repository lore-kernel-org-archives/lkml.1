Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbYHIFV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbYHIFV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 01:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYHIFVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 01:21:17 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:45301 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYHIFVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 01:21:17 -0400
Message-ID: <489D2954.9090309@keyaccess.nl>
Date: Sat, 09 Aug 2008 07:21:24 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] PNP: make the resource type an unsigned long
References: <489BEA31.3040101@keyaccess.nl> <489CC0DD.5010402@zytor.com>
In-Reply-To: <489CC0DD.5010402@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-08-08 23:55, H. Peter Anvin wrote:

>> Andrew earlier commented that pci_resourec_flags() returns an unsigned 
>> long. Had this hanging around a local branch. Useful?
>>
> 
> -int pnp_resource_type(struct resource *res)
> +unsigned long pnp_resource_type(struct resource *res)
>  {
>      return res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
>                   IORESOURCE_IRQ | IORESOURCE_DMA);
>  }
> 
> Seems a bit pointless ... either one of those flags is >= 32 bits, in 
> which case we need u64, or it's not, in which case there is no reason to 
> burden the output with bits we don't need.

Yes, it's a not a functional patch -- only a type-consistency one. Right 
now we're mixing ints (signed ones even) and unsigned longs and while in 
this case that's not a functional problem it's messy and inconsistent.

I agree (as Andrew said earlier as well) that the struct resource flags 
member should probably just be a u32 but it's not. Changing that would 
be a bigger change than just a simple conistency thing.

Rene.
