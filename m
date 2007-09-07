Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbXIGXiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbXIGXiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXIGXiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:38:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:20088 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbXIGXiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:38:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,222,1186383600"; 
   d="scan'208";a="274256866"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch for Intel Tolapai
Date: Fri, 7 Sep 2007 16:37:58 -0700
Message-ID: <39B20DF628532344BC7A2692CB6AEE0701BCF3B5@orsmsx420.amr.corp.intel.com>
In-Reply-To: <46E1D313.2060302@pobox.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch for Intel Tolapai
thread-index: Acfxn/E2DCTyf5mfQtWiS/mZeElj3QAB+2WQ
References: <200708302127.19535.jason.d.gaston@intel.com> <46D7C783.8050803@pobox.com> <39B20DF628532344BC7A2692CB6AEE0701B9A4CA@orsmsx420.amr.corp.intel.com> <46E1D313.2060302@pobox.com>
From: "Gaston, Jason D" <jason.d.gaston@intel.com>
To: "Jeff Garzik" <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Sep 2007 23:37:58.0765 (UTC) FILETIME=[1F7109D0:01C7F1A8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Jeff Garzik [mailto:jgarzik@pobox.com]
>Sent: Friday, September 07, 2007 3:39 PM
>To: Gaston, Jason D
>Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch
for
>Intel Tolapai
>
>Gaston, Jason D wrote:
>>> -----Original Message-----
>>> From: Gaston, Jason D
>>> Sent: Friday, August 31, 2007 10:10 AM
>>> To: 'Jeff Garzik'
>>> Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
>>> Subject: RE: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch
>> for
>>> Intel Tolapai
>>>
>>> This device has both AHCI and RAID modes that use the ahci driver.
>> Only
>>> the RAID mode DID's are being added as the PCI class code support
will
>>> cover the AHCI mode.  Looking at the Generic, PCI class code support
>>> section, it uses "board_ahci".  I assumed that they should be the
same
>> as
>>> the generic class code support is working on this platform.
>>>
>>> Thanks,
>>>
>>> Jason
>>>
>>>
>>>> -----Original Message-----
>>>> From: Jeff Garzik [mailto:jgarzik@pobox.com]
>>>> Sent: Friday, August 31, 2007 12:47 AM
>>>> To: Gaston, Jason D
>>>> Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
>>>> Subject: Re: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA
patch
>> for
>>>> Intel Tolapai
>>>>
>>>> Jason Gaston wrote:
>>>>> Resend trying to remove 8-bit characters in the email.
>>>>>
>>>>> This patch adds the Intel Tolapai RAID controller DID's for SATA
>>> support.
>>>>> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
>>>>>
>>>>> --- linux-2.6.23-rc4/drivers/ata/ahci.c.orig	2007-08-27
>>>> 18:32:35.000000000 -0700
>>>>> +++ linux-2.6.23-rc4/drivers/ata/ahci.c	2007-08-28
>>> 16:58:11.000000000 -
>>>> 0700
>>>>> @@ -411,6 +411,8 @@
>>>>>  	{ PCI_VDEVICE(INTEL, 0x292f), board_ahci_pi }, /* ICH9M */
>>>>>  	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci_pi }, /* ICH9 */
>>>>>  	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci_pi }, /* ICH9M */
>>>>> +	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
>>>>> +	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
>>>> Why did you not use board_ahci_pi?  Is the AHCI ports-implemented
>>>> register unreliable on this platform?
>>
>> Jeff,
>>
>> Do I need to change this to board_ahci_pi or is it ok to leave it at
>> board_ahci, which will be used by the AHCI class code devices?
>
>You are the one who needs to answer this question ;-)
>
>Most new Intel AHCI have a sane and reliable Ports-Implemented register
>value even across reset, unlike earlier ones or some clones.  For
those,
>we use board_ahci_pi.
>
>If PI is not reliable across reset or if BIOS is absent (yes we care
>about that case, when we do our own PCI resume for example), then you
>should use board_ahci.
>
>	Jeff

At this time, I don't have any way to test those particular DeviceID's
and I know that the AHCI mode DeviceID works by using the class code
support.  So, I would like to just leave them at they are, if that is
ok.

Thanks,

Jason
