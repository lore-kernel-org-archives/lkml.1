Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZHKPI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZHKPI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZHKPI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:08:28 -0400
Received: from vena.lwn.net ([206.168.112.25]:46756 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbZHKPI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:08:27 -0400
Date: Tue, 11 Aug 2009 09:05:54 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "B.Vinai Kumar" <vinaibangala2001@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to get the address of the page structure from the given
 virtual  address?
Message-ID: <20090811090554.79a1b1ac@bike.lwn.net>
In-Reply-To: <f74c922b0908110731ifcf162ai8770f07d7ca537d3@mail.gmail.com>
References: <f74c922b0908110731ifcf162ai8770f07d7ca537d3@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 20:01:41 +0530
"B.Vinai Kumar" <vinaibangala2001@gmail.com> wrote:

> 1) I allocated 8 pages using alloc_pages(GFP_KERNEL, 3). This function
> returns the pointer to the first page's page structure.
> How can I get the page structure address of the remaining 7 pages?

They will be immediately following the first page structure in the
system memory map - they are contiguous pages, after all.  So just use
pointer arithmetic to find them.  

Inquiring minds are indeed curious as to why you need them, though :)
> 
> 2) There is a function page_address() which takes the page structure
> as an argument and returns the virtual address of the page
>  that is pointed by that page structure. 

Note that page_address() may not give you a valid address if it's a
high-memory page which is not currently mapped.

> Is there any method which
> retrives the address of the page structure?

Use virt_to_page() for normal kernel virtual addresses,
vmalloc_to_page() for memory in the vmalloc range.

jon
