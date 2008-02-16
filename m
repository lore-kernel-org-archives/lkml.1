Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYBPUHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYBPUHK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbYBPUG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:06:58 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:28824 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbYBPUG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:06:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gPYQCbmHJfTiyCIRwEizopT33e6ELXXKthdKr/pr3Me3OJ0NKXwGUVa241B/GSNaWkmNaL919KZATM3FQEZLmm3N/ZTgBhxoBCZFxLPBhIqmcCJgoVZEBO3ReHkp6HC5Qo+TGkFm8tmcO9I6tlLOC+yZpN/6DWyX1tY2UPdQ5n0=
Message-ID: <e9c3a7c20802161206n6fdece7dk3c442144458ad472@mail.gmail.com>
Date: Sat, 16 Feb 2008 13:06:54 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@norway.atmel.com>
Subject: Re: [RFC v3 4/7] dmaengine: Add slave DMA interface
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <20080215105302.1e4251a3@dhcp-252-066.norway.atmel.com>
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
X-Google-Sender-Auth: 74c163c4c9faa8b6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 15, 2008 2:53 AM, Haavard Skinnemoen
<hskinnemoen@norway.atmel.com> wrote:
> On Wed, 13 Feb 2008 20:24:02 +0100
> Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
>
> > But looking at your latest patch series, I guess we can use the new
> > "next" field instead. It's not like we really need the full
> > capabilities of list_head.
>
> On second thought, if we do this, we would be using the "next" field in
> an undocumented way. It is currently documented as follows:
>
>  * @next: at completion submit this descriptor
>
> But that's not how we're going to use it when doing slave transfers:
> We're using it to keep track of all the descriptors that have already
> been submitted.
>
> I think it would actually be better to go the other way and have the
> async_tx API extend the descriptor as well for its private fields. That
> way, we get the pointer we need, but we can document it differently.
>
> So how about we do something along the lines of the patch below? We
> need to update all the users too of course, but apart from making the
> dma_slave_descriptor struct smaller, I don't think it will change the
> actual memory layout at all.
>

I like the direction of the patch, i.e. splitting out separate
functionality into separate structs.  However, I do not want to break
the model of clients sourcing the operations and drivers sinking them
which dma_slave_descriptor appears to do.  How about adding a
scatterlist pointer and an 'unmap_type' to the common descriptor?
Where unmap_type selects between,  page, single, sg, or no-unmap.
Drivers already know the length and direction.

Regards,
Dan
