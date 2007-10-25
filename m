Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbXJYCr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbXJYCr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXJYCrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:47:18 -0400
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:27026 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751966AbXJYCrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:47:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HS/uQf+aaZ9d5BuOCFxKop5tO/64+JekiXwhEH/3FkXx4rLaqjwlVk44GmTZOiEj+trC64ywYkU31P30BhQpMODCpQyRVGgBoosLC90OlBbMStU/A/XHt83nqg7X3AYYfW60KoX+WYt8QRdjWKJfcgrrpc4HYX0gsti7vFT8FVk=  ;
X-YMail-OSG: jvEFNPoVM1n7M_zOcb6IiA1wMFknFI82I6.0lz.l8lX5N6DRevd.MELyuizhhhZl6DeuxhKWCw--
From: David Brownell <david-b@pacbell.net>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 2.6.24-rc1] resource_len() utility function
Date: Wed, 24 Oct 2007 19:47:14 -0700
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
References: <200710241820.52376.david-b@pacbell.net> <20071025024405.3e960e9c@the-village.bc.nu> <471FFA91.3040306@garzik.org>
In-Reply-To: <471FFA91.3040306@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710241947.15129.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007, Jeff Garzik wrote:
> With regards to resource reservation...  IMO we should mimic struct 
> pci_dev and add struct resource[] to struct device.

One minor difficulty:  PCI has a limit on the number of BARs,
but other busses don't.  It'd be better as a "struct resource *".


> Just like we have pci_request_regions(), we should also be able to 
> easily to a dev_request_regions().  the implementation should be very 
> close to pci_request_region() and pci_release_region().

Wouldn't it be nicer to have PCI use those dev_*() calls?
Ideally pci_request_region() wraps dev_request_region()...


> Then a dev_iomap() analogue to pci_iomap() should be pretty 
> straightforward to create.

Another minor nit:  addressing the various resource types.
The platform bus code has multiple lookup schemes. 

Calls like resource_iomap() might be more flexible, so that
lookup schemes can stay flexible.

- Dave
