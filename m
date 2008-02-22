Return-Path: <linux-kernel-owner+w=401wt.eu-S1762136AbYBVKev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136AbYBVKev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYBVKel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:34:41 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:65023 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbYBVKek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:34:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LTl2ud+jycPaILIvehjAMpCxbn8RUgFsTqD80UkVM76djpA5MW833bQSo58eto5UnaWK7TKQXuhsuASIWjS/ZGHVbAYulKB2w9T4mYyx0C7BrUyig+NeIxhcWexmFd2MNrJg2zSlZ++IonDx6FPIqxUpDg1kioHXN6ojxY3nGgQ=
Message-ID: <47BEA53B.6090903@gmail.com>
Date: Fri, 22 Feb 2008 11:34:35 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@osdl.org, jeff@garzik.org
Subject: Re: GAK!!!! Re: PCI: AMD SATA IDE mode quirk
References: <200802220059.m1M0xgjZ022717@hera.kernel.org>	<20080222094828.2a0124ca@core> <20080222100205.5c86d351@core>
In-Reply-To: <20080222100205.5c86d351@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2008 11:02 AM, Alan Cox wrote:
> On Fri, 22 Feb 2008 09:48:28 +0000
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>>>     Signed-off-by: Crane Cai <crane.cai@amd.com>
>>>     Acked-by: Jeff Garzik <jeff@garzik.org>
>>>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>> Vomitted-upon-by: Alan Cox <alan@redhat.com>
>>
>>> -	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
>>> -		u8 tmp;
>>> +	/* set sb600/sb700/sb800 sata to ahci mode */
>>> +	u8 tmp;
>>>  
>>> +	pci_read_config_byte(pdev, PCI_CLASS_DEVICE, &tmp);
>>> +	if (tmp == 0x01) {
>> CLASS_DEVICE is cached in pdev->class so why not simply do:
>>
>> 	if (pdev->class & (1 << 8))
> 
> or better yet
> 
> 	((pdev->class & 0xFF00) == 0x0100)

Isn't it what was there before the change:
 >>> -	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
 >>> -		u8 tmp;
and there was some reason to change it?
