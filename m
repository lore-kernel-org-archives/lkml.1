Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbYBYWxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbYBYWxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758184AbYBYWx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:53:26 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48815 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618AbYBYWxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:53:25 -0500
Message-ID: <47C346E2.10908@garzik.org>
Date: Mon, 25 Feb 2008 17:53:22 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@osdl.org, "Cai, Crane" <Crane.Cai@amd.com>
Subject: Re: GAK!!!! Re: PCI: AMD SATA IDE mode quirk
References: <200802220059.m1M0xgjZ022717@hera.kernel.org> <20080222094828.2a0124ca@core>
In-Reply-To: <20080222094828.2a0124ca@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>     Signed-off-by: Crane Cai <crane.cai@amd.com>
>>     Acked-by: Jeff Garzik <jeff@garzik.org>
>>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Vomitted-upon-by: Alan Cox <alan@redhat.com>
> 
>> -	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
>> -		u8 tmp;
>> +	/* set sb600/sb700/sb800 sata to ahci mode */
>> +	u8 tmp;
>>  
>> +	pci_read_config_byte(pdev, PCI_CLASS_DEVICE, &tmp);
>> +	if (tmp == 0x01) {
> 
> CLASS_DEVICE is cached in pdev->class so why not simply do:
> 
> 	if (pdev->class & (1 << 8))

I agree.  I [obviously] missed this when I ack'd, mainly ack'ing the 
overall change.

BIOS certainly may modify that PCI config register, but that's before 
the kernel boots.  So, using pdev->class is fine.

	Jeff



