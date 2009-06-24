Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbZFXOWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbZFXOWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZFXOVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:21:53 -0400
Received: from fmailhost05.isp.att.net ([207.115.11.55]:42799 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbZFXOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:21:53 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A423686.8050905@lwfinger.net>
Date: Wed, 24 Jun 2009 09:21:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Gary Hade <garyhade@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
References: <4A418254.9050607@lwfinger.net> <1245845787.3093.3.camel@localhost.localdomain>
In-Reply-To: <1245845787.3093.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Tue, 2009-06-23 at 20:33 -0500, Larry Finger wrote:
>> My latest pull from Linus's tree fails to boot. Bisection leads to the
>> commit entitled "x86/ACPI: Correct maximum allowed _CRS returned
>> resources and warn if exceeded" with hash
>> f9cde5ffed17bf74f6bef042d99edb0622f58576. I have been unable to
>> capture the first error message as it scrolls off the screen, but the
>> second hits the WARN_ON at drivers/ata/ahci.c:695 in routine
>> ahci_enable_ahci() because HOST_AHCI_EN is not set.
>>
> 
> This patch fixes boot failure on my AMD 64 laptop, can you please test
> this patch:
> 
> [PATCH] x86: fix _CRS resources return handling
> 
> We need to check for info->res_num and only handle for < PCI_BUS_NUM_RESOURCES
> 
> Also set info->bus->resource[info->res_num] for _CRS resources return handling
> 
> Fixed boot failure on some machine.
> 
> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/pci/acpi.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks for the patch. With it, my machine boots with the latest
2.6.30-gitX.

For the record, the printout from the patch results in the following:

PCI: Failed to allocate 0xd0000-0xd3fff from PCI mem for PCI Bus 0000:00
PCI: Failed to allocate 0xec000-0xeffff from PCI mem for PCI Bus
0000:00 due to _CRS returning more than 13 resource descriptors
PCI: Failed to allocate 0xf0000-0xfffff from PCI mem for PCI Bus
0000:00 due to _CRS returning more than 13 resource descriptors
PCI: Failed to allocate 0xc0000000-0xfebfffff from PCI mem for PCI Bus
0000:00 due to _CRS returning more than 13 resource descriptors

Larry
