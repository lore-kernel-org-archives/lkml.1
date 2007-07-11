Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbXGKDfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbXGKDfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 23:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbXGKDey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 23:34:54 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:49674 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893AbXGKDep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 23:34:45 -0400
Date: Tue, 10 Jul 2007 21:34:07 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: ASUS P5B
In-reply-to: <fa.ndldafKtK099qJxXxYZ1NeVvReQ@ifi.uio.no>
To: Piotr <kocur666@tlen.pl>
Cc: linux-kernel@vger.kernel.org
Message-id: <46944FAF.8090507@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ndldafKtK099qJxXxYZ1NeVvReQ@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Piotr wrote:
> Hello i have a problem with my ASUS p5b mobo, i am a gentoo user and i'm
> getting this error while booting my system from newest gentoo-sources
> 2.6.22 (this also happens on earlier ver. of kernel) i get this message:
> 
> "PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
> PCI: Not using MMCONFIG."
> 
> and i dunno how can this be fixed, i can start to boot my kernel with
> nommconf but i don' like to have problems like that, and maybe some of
> you ppl have a better solution for this problem?

It's not a huge problem, it mainly just means that extended PCI Express 
configuration space can't be accessed, and that doesn't seem to be used 
much currently.

Actually, the E820 validation check in mainline currently is too strict 
as the MMCONFIG area is not required to be reserved in the E820 table. 
There's a patch in the -mm tree to validate this against ACPI 
motherboard resources instead, as well as a fix to a PCI probing issue 
that caused problems on some Intel boards with MMCONFIG enabled. You can 
try an -mm kernel and see if this is resolved.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

