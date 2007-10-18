Return-Path: <linux-kernel-owner+w=401wt.eu-S1762693AbXJRJFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbXJRJFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759130AbXJRJE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:04:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:28105 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123AbXJRJEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:04:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZXJhTiWxGg8GO10/3BYTZC6LpLToF1PlM/4FulGFvhfCROzz68lo/tgGPqUfZY6D4w0/Z+l9+L47qlJV6+1tPN8R7T2zvCVbRtd3XvvlkIl3b1tXxoS0iITZIFNIvIspo+3gEWEca5TC+R87k+G0P9m0oK5tp0a71u+yRWPFmKs=
Message-ID: <471721B2.4050506@gmail.com>
Date: Thu, 18 Oct 2007 11:04:50 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "S. Vishnu Priya" <vpriya@lantana.tenet.res.in>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: bad reads from pci bars after inserting card [Was: card details]
References: <Pine.LNX.4.64.0710181421050.31716@lantana.tenet.res.in>
In-Reply-To: <Pine.LNX.4.64.0710181421050.31716@lantana.tenet.res.in>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2007 10:51 AM, S. Vishnu Priya wrote:
> Thankyou so much for your valuable suggestions.
> 
> I have gone through the link. In the configuration space we will be
> having the total size for each Bar regions. When i insert my card in the
> pci slot i am getting one set of address for the BAR regions. With that

So if I understand correctly, you have a pci hotplug capable mainboard? Or what
do you insert and where?

> address as the base address i did memory mapping and try to access FPGA
> registers i couldn't access. Some junk data's are coming. For this
> problem if i reboot my PC, i am getting the another set of address and
> follow the same procedure. I am able to access all my FPGA registers.
> 
> So for the first time i am not getting address properly. Once reboot i
> can able to retrieve the values. Can you clarify me where the problem
> could be?

Hmm, me no, Cc-ing Greg and lkml.

Maybe outputs from lspci -vvxxx would be good when you plug the card in and
after reboot. I suspect the card is not reset somehow rather than pci layer, so
that the plx bridge doesn't translate the reads/writes correctly.

> On 10/18/2007 10:17 AM, S. Vishnu Priya wrote:
>>    Actually i mean to ask this question. Through the below codings we
>> can retrieve the details through our driver. My doubt is, once our card
>> has been inserted in the PCI slot we can able to see some information of
>> our card in this file /proc/bus/pci/devices.
>>
>>> From where kernel will get these details from the card ie from EEPROM or
>> from some other register?
> 
> see the second link and the line above it...
> 
>> It prints the contents of pci_dev structures:
>> http://www.linux-m32r.org/lxr/http/source/drivers/pci/proc.c#L335
>> which is retrieved from pci config space; mostly everything from here:
>> http://www.linux-m32r.org/lxr/http/source/drivers/pci/probe.c
