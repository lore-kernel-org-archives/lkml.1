Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXDIVz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXDIVz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbXDIVz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:55:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbXDIVzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:55:25 -0400
Message-ID: <461AB643.8020509@redhat.com>
Date: Mon, 09 Apr 2007 17:55:15 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, akpm@osdl.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@canonical.com
Subject: Re: [PATCH] HPA support: Revised patch
References: <20070405141352.12fddb6e@the-village.bc.nu>	<20070406163707.GA25880@srcf.ucam.org> <20070409222241.6581ecc2@the-village.bc.nu>
In-Reply-To: <20070409222241.6581ecc2@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 6 Apr 2007 17:37:07 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
>> On Thu, Apr 05, 2007 at 02:13:52PM +0100, Alan Cox wrote:
>>> This one should fix the problems with slave devices and the Macintosh hang
>> Better, but still not happy with ata_piix - I get the following:
>>
>> [   10.972000] ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 16337840
>> [   10.972000] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
>> [   10.972000] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
>> [   10.980000] ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = -1342616656
>> [   10.980000] ata3.01: Host Protected Area detected:
>> [   10.980000] 	current size: 234441648 sectors
>> [   10.980000] 	native size: -1342616656 sectors
>>                              ^^^^^^^^^^^!?!?!?!?!?!?!?
>>
>> so I'm not especially keen on letting it reprogram stuff. With ahci it 
>> works fine. Still on a Macbook Pro - fuller logs below.
> 
> Please apply Tejun's fix for LBA48 data and try again. Hopefully its just
> that which is causing the problem.
> 

This?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=4742d54fa4b391342dfb8f34de14d51da101fb39

    2.6.21 fix lba48 bug in libata fill_result_tf()

Looks like 2.6.20 material as well.
