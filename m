Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbYB2ML3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbYB2ML3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbYB2MLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:11:20 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:39937 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbYB2MLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:11:19 -0500
Message-ID: <47C7F664.5040102@garzik.org>
Date: Fri, 29 Feb 2008 07:11:16 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tejun Heo <htejun@gmail.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: devres and requesting resources
References: <47C75392.3020606@garzik.org> <20080229112651.5b2a7f6f@core>
In-Reply-To: <20080229112651.5b2a7f6f@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> In converting to pcim_iomap_regions(), we no longer reserve /all/ 
>> regions, only the ones requested.
>>
>> This is actually a bug:  it was intentional to call 
>> pci_request_regions(), because that ensures that no other software will 
>> use our resources -- even if we are not actively using the resource in 
>> question.
> 
> That would be a bug. We should only reserve the regions we are using. It
> is possible that the other regions can be used correctly by another driver
> (consider the CS5520 or the MPIIX where the IDE is only part of one
> function of the PCI device).

Only rare PCI devices are shareable among multiple drivers.

sata_* at least intentionally used pci_request_regions() because it is 
obvious from the hardware spec that multiple regions accessed by 
multiple drivers is highly unlikely, without the driver being 
specifically coded to support such sharing.  Such sharing code is far 
beyond simple resource reservation, to avoid stepping on toes when there 
is a single MMIO region and set of interrupt clearing registers.

So reading your email it sounds like there are valid cases for both 
configurations.

Its a design choice either way, not a bug either way.

	Jeff


