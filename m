Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbXIGWj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbXIGWj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 18:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758666AbXIGWjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 18:39:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49065 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758480AbXIGWjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 18:39:19 -0400
Message-ID: <46E1D313.2060302@pobox.com>
Date: Fri, 07 Sep 2007 18:39:15 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Gaston, Jason D" <jason.d.gaston@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch for Intel
 Tolapai
References: <200708302127.19535.jason.d.gaston@intel.com> <46D7C783.8050803@pobox.com> <39B20DF628532344BC7A2692CB6AEE0701B9A4CA@orsmsx420.amr.corp.intel.com>
In-Reply-To: <39B20DF628532344BC7A2692CB6AEE0701B9A4CA@orsmsx420.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gaston, Jason D wrote:
>> -----Original Message-----
>> From: Gaston, Jason D
>> Sent: Friday, August 31, 2007 10:10 AM
>> To: 'Jeff Garzik'
>> Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: RE: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch
> for
>> Intel Tolapai
>>
>> This device has both AHCI and RAID modes that use the ahci driver.
> Only
>> the RAID mode DID's are being added as the PCI class code support will
>> cover the AHCI mode.  Looking at the Generic, PCI class code support
>> section, it uses "board_ahci".  I assumed that they should be the same
> as
>> the generic class code support is working on this platform.
>>
>> Thanks,
>>
>> Jason
>>
>>
>>> -----Original Message-----
>>> From: Jeff Garzik [mailto:jgarzik@pobox.com]
>>> Sent: Friday, August 31, 2007 12:47 AM
>>> To: Gaston, Jason D
>>> Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
>>> Subject: Re: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch
> for
>>> Intel Tolapai
>>>
>>> Jason Gaston wrote:
>>>> Resend trying to remove 8-bit characters in the email.
>>>>
>>>> This patch adds the Intel Tolapai RAID controller DID's for SATA
>> support.
>>>> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
>>>>
>>>> --- linux-2.6.23-rc4/drivers/ata/ahci.c.orig	2007-08-27
>>> 18:32:35.000000000 -0700
>>>> +++ linux-2.6.23-rc4/drivers/ata/ahci.c	2007-08-28
>> 16:58:11.000000000 -
>>> 0700
>>>> @@ -411,6 +411,8 @@
>>>>  	{ PCI_VDEVICE(INTEL, 0x292f), board_ahci_pi }, /* ICH9M */
>>>>  	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci_pi }, /* ICH9 */
>>>>  	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci_pi }, /* ICH9M */
>>>> +	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
>>>> +	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
>>> Why did you not use board_ahci_pi?  Is the AHCI ports-implemented
>>> register unreliable on this platform?
> 
> Jeff,
> 
> Do I need to change this to board_ahci_pi or is it ok to leave it at
> board_ahci, which will be used by the AHCI class code devices?

You are the one who needs to answer this question ;-)

Most new Intel AHCI have a sane and reliable Ports-Implemented register 
value even across reset, unlike earlier ones or some clones.  For those, 
we use board_ahci_pi.

If PI is not reliable across reset or if BIOS is absent (yes we care 
about that case, when we do our own PCI resume for example), then you 
should use board_ahci.

	Jeff



