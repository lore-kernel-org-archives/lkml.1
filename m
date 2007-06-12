Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbXFLOlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbXFLOlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbXFLOlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:41:19 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:37074 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbXFLOlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:41:14 -0400
Date: Tue, 12 Jun 2007 08:40:32 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: allocation failed: out of vmalloc space - use vmalloc=<size> to
 increase size.
In-reply-to: <fa.VH1FnGj5K9OwLz/eErQti4itl2k@ifi.uio.no>
To: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Message-id: <466EB060.5040708@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.VH1FnGj5K9OwLz/eErQti4itl2k@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Dufresne wrote:
> I am writing a linux kernel driver for a custom pci device. I am
> developing against the stock fedora 6 kernel on an x86. This device has
> 512 MB of IO memory reserved by BAR 3. Whenever I try to ioremap this
> space I get the error:
> 
> allocation failed: out of vmalloc space - use vmalloc=<size> to increase
> size.
> 
> I think I understand why this is happening. I obviously don't have
> enough vmalloc space to map such a large chunk of memory. I have been
> using Corbet's et el's "Linux Device Drivers", Love's "Linux Kernel
> Development", and many websites as a guide in this development process
> but have yet to come across information that will help me.
> 
> I'm curious if there is a way around this issue. Or a better way of
> handling it so that I can properly map the entire io memory space.

On an i386 kernel you likely just don't have enough address space 
available to map something that big. Your kernel address space is only 
1GB (with the standard 3G/1G user/kernel split) and it somehow has to 
fit in there along with all the other I/O regions, etc. that are mapped 
into kernel address space.

You may just have to remap smaller chunks of the BAR on demand and unmap 
them when you're finished with them.

An x86_64 kernel likely would not have this problem..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

