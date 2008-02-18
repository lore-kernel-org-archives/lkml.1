Return-Path: <linux-kernel-owner+w=401wt.eu-S1761856AbYBRWmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761856AbYBRWmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYBRWmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:42:10 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:57635 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbYBRWmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:42:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hUINjyzdTDAF+XgN7V6mFaoX8cCXL6ggsI7/u/mqS1LF56NEIeigS5w2vhlFteRPey5vhi5R22w6MilmF4QrRzrYhVZYtXDx15nFhkXSJqMHRB3glqElsX+bU0xZ8L0Tp7jT0/uJHZsD0QKTtw3PUSpO/Q1R/8VnuwId5CfpbA0=
Message-ID: <e9c3a7c20802181442q60d94a77rfff8ce4a9f3087b3@mail.gmail.com>
Date: Mon, 18 Feb 2008 15:42:07 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC v3 4/7] dmaengine: Add slave DMA interface
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <20080218142239.43809da7@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
	 <e9c3a7c20802131107x4c9e6859p3bc6527b19c416cb@mail.gmail.com>
	 <20080213202402.22818482@siona>
	 <20080215105302.1e4251a3@dhcp-252-066.norway.atmel.com>
	 <e9c3a7c20802161206n6fdece7dk3c442144458ad472@mail.gmail.com>
	 <20080218142239.43809da7@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 726254a4a580bd8f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18, 2008 6:22 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> On Sat, 16 Feb 2008 13:06:54 -0700
> "Dan Williams" <dan.j.williams@intel.com> wrote:
>
> > I like the direction of the patch, i.e. splitting out separate
> > functionality into separate structs.  However, I do not want to break
> > the model of clients sourcing the operations and drivers sinking them
> > which dma_slave_descriptor appears to do.  How about adding a
> > scatterlist pointer and an 'unmap_type' to the common descriptor?
> > Where unmap_type selects between,  page, single, sg, or no-unmap.
> > Drivers already know the length and direction.
>
> But there are currently no operations available for submitting
> scatterlists as a single descriptor -- the client iterates over the
> scatterlist and submits one descriptor for each entry. So there's no
> way you can associated a scatterlist with a single descriptor. You can
> perhaps attach it to the last one, but that may get you into trouble if
> the transfer is terminated early for some reason.
>

Drivers know how to treat a group of descriptors as one operation.  I
see this as no different than the case where an operation exceeds the
hardware's per descriptor max transfer length.  The driver internally
creates extra descriptors but the client only needs to worry about one
handle.

[..]

> Btw, this discussion is a bit off-topic for the patch in question, but
> it's an issue that needs to be resolved.
>

Agreed, more code less words :-).  I'll try to brew this into a patch.

--
Dan
