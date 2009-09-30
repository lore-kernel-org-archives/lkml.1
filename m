Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbZI3Md3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbZI3Md3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZI3Md2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:33:28 -0400
Received: from mastodon.hardc0re.org.uk ([77.240.12.146]:44322 "EHLO
	mastodon.hardc0re.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZI3Md2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:33:28 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2009 08:33:27 EDT
Message-ID: <0b59b7dd4a320d3be58bc74455932cc0.squirrel@www.hardc0re.org.uk>
In-Reply-To: <4AC2A300.1040001@gmail.com>
References: <4AC2604C.2060803@hardc0re.org.uk> <4AC2A300.1040001@gmail.com>
Date: Wed, 30 Sep 2009 13:23:37 +0100 (BST)
Subject: Re: VIA VT6330 PCI-E Combo Controller not fully supported
From: chrisfu@mastodon.hardc0re.org.uk
To: linux-kernel@vger.kernel.org
Cc: "Chris M" <chrisfu@hardc0re.org.uk>,
       "Robert Hancock" <hancockrwd@gmail.com>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 09/29/2009 01:30 PM, Chris M wrote:
>> Hi everyone!  I'll quickly introduce myself before I get to the crux of
>> my reason for posting to the mailing list. My name is Chris Merrett and
>> although I'm not a subscriber to the list (my mail server would likely
>> cry), I check a well-known archive quite regularly just to try and keep
>> on top of developments in the community.
>>
>> The reason I'm mailing is due to a partially-supported VIA chip present
>> on a small handful of motherboards currently on sale. I mailed the
>> maintainer (Jeff Garzik) to bring this to his attention quite some time
>> ago, but I'd imagine he's not found the time to reply to me yet which is
>> understandable. I figured that it'd be a good idea to make a post here
>> with the info I've gathered, so that people affected by this same issue
>> are aware that this particular chip isn't yet fully supported in the
>> kernel.
>>
>> The VT6330 is a combo controller chip that handles both Firewire and
>> PATA, and is present on my Asrock N7AD-SLI. I'm also aware of it being
>> present on other Asrock boards, and presumably other boards from
>> different manufacturers. The Firewire functionality is supported
>> perfectly and without issue, but unfortunately the PATA support is
>> lacking at the moment. VIA have some information on this at the
>> following URL:
>> http://www.via.com.tw/en/products/peripherals/1394/vt6330/
>>
>>  From the info on the URL above, it appears that the PATA functionality
>> is identical to that of the VT6415 PATA controller, support for which
>> was added in 2.6.28. The mailing list post made regarding the patch that
>> was submitted can be found here:
>> http://lkml.indiana.edu/hypermail/linux/kernel/0902.2/01428.html
>
> If it is similar enough to the existing controllers then you may be able
> to just add the device ID into pata_via in a similar fashion..
>

Thanks for your feedback Robert.  I went to do exactly that yesterday
evening,
and found some interesting stuff.  The PATA functionality of the VT6330
identifies itself as the VT6415 and uses the exact same pci_id, meaning that
support was already added in the mailing list post I quoted in my original
mail.

The perplexing thing is that the device is unclaimed even though that by all
accounts, it should be picked up.

A snippet from dmesg:

[    4.970261] pata_via 0000:01:00.1: version 0.3.3
[    4.970637] ACPI: PCI Interrupt Link [LN6A] enabled at IRQ 19
[    4.970643] pata_via 0000:01:00.1: PCI INT A -> Link[LN6A] -> GSI 19
(level,
low) -> IRQ 19
[    4.970709] pata_via 0000:01:00.1: PCI INT A disabled
[    4.970774] pata_acpi 0000:01:00.1: PCI INT A -> Link[LN6A] -> GSI 19
(level,
low) -> IRQ 19
[    4.970799] pata_acpi 0000:01:00.1: setting latency timer to 64
[    4.970809] pata_acpi 0000:01:00.1: PCI INT A disabled

I guess I'll just keep probing and see what I can come up with.  The next
step
is trying to find out if the changes to support the VT6415 worked for
*anyone*. :)

Warm regards,

Chris M

