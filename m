Return-Path: <linux-kernel-owner+w=401wt.eu-S1762910AbXGFMph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762910AbXGFMph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762277AbXGFMpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:45:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:20310 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761127AbXGFMpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:45:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ZQ/I8RMif2owB/S9THMvWl8Udh0w3Zq+pHY8csPLYb2o+U/VsSiN/UUcHaddJXr4j
	KPEKPIRnj/tBeDpxlOJNQ==
Message-ID: <8f95bb250707060545t70597766i48bda1516c7c8111@mail.gmail.com>
Date: Fri, 6 Jul 2007 05:45:06 -0700
From: "Aaron Durbin" <adurbin@google.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] i386/x86_64: Insert HPET firmware resource after PCI enumeration has completed
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, matthias.lenk@amd.com
In-Reply-To: <200707061259.36526.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070705222724.GA12537@google.com> <200707061259.36526.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/6/07, Andi Kleen <ak@suse.de> wrote:
> On Friday 06 July 2007 00:27:24 Aaron Durbin wrote:
> >
> > Insert HPET resources after pci probing has been completed in order to avoid
> > resource conflicts with PCI resource reservation. With this change the
> > HPET firmware resources will be identified, but it should also not cause
> > issues when the HPET address falls on a BAR in a PCI device, and the PCI
> > enumeration cannot reserve the resources.
>
> But what advantage does it have when it's already reserved by PCI?
>
> That's only a cosmetic change, isn't it?  A lot of code for cosmetics.
>

To my knowledge, not every machine has the HPET live on a BAR in PCI space. It
is cosmetic, but it shows what devices are using what memory address space in
/proc/iomem so one doesn't need to dig through dmesg to piece things together.

I am going to work w/ Matthias to see if we can get a patch working with his
system. I think that it is beneficial to easily view where resources are being
used, but I do understand the prudence.

-Aaron
