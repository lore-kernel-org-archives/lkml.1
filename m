Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbXFXToY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbXFXToY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbXFXToR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:44:17 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:21916 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbXFXToQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:44:16 -0400
Date: Sun, 24 Jun 2007 13:44:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: character driver over PCI
In-reply-to: <1182686296.981507.296500@z28g2000prd.googlegroups.com>
To: ats <atita84@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <467EC986.7040300@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <1182686296.981507.296500@z28g2000prd.googlegroups.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ats wrote:
>  have a  wireless network card over PCMCIA....i need to just access
> the registers of this card and pass this register details to the user
> application.Since i will not connect to the network at this stage i
> preferred bypassing the network stack.Hence instead of a network
> driver i went ahead writing a character driver.
> 
> 
> I inserted the PCI module using insmod..That called PCI
> probe....Inside PCI probe i registered by character driver by calling
> register_chrdev().And i remapped the card memory by calling the
> following sequence of functions.
> 
> 
> pci_resource_start
> request_mem_region
> ioremap
> 
> Then i created a device using mknod and called the open function of
> the character driver.....Till here everything works fine....
> 
> 
> Once the device opened i made a readl call to read the mapped
> memory..This fails..It gives me a segmentation fault.....If i call
> readl in the probe function it works fine and reads the memory at that
> location..However this call fails in open..What can be the reason...
> 
> Have i proceeded the right way....Are there any additional things to
> be set..Am working on linux 2.6 kernel
> 
> Attached below is my prog

I don't see where it is trying to read anything in this code. The way in 
which you're doing that is likely the problem..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

