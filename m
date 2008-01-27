Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYA0JVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYA0JVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYA0JVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:21:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:21627 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbYA0JVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:21:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XHGaeJoLMXIAFKaSG4bsmEfaLtzqrCbqcYycyxhlt3jKdrAyzO3kHfIX9wUsYvUfbg1hBv1k4yHwL37FgBTIiDP//z9meCyNC16aZ8lEbtrRY5RlKL70IISg1UimF4eDyfxt4gAVshZV617qqNx2zg8vZ6BkhD38zxnvuBe/P+A=
Message-ID: <479C4D08.4020800@gmail.com>
Date: Sun, 27 Jan 2008 10:21:12 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Jeff Garzik <jeff@garzik.org>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: (Updated) [Patch] Shut up warnings from files under drivers/
References: <20080126093007.GB20935@hacking> <479B03AE.3090600@garzik.org> <20080126191717.GA25701@uranus.ravnborg.org> <20080127041521.GC2495@hacking> <479C49F4.8060800@gmail.com>
In-Reply-To: <479C49F4.8060800@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2008 10:08 AM, Jiri Slaby wrote:
> On 01/27/2008 05:15 AM, WANG Cong wrote:
>> Fix defined-but-not-used warnings from files under drivers/,
>> such as:
>>
>> drivers/char/applicom.c:68: warning: ‘applicom_pci_tbl’ defined but 
>> not used
>>
>> Compile tests passed.
>>
>> Cc: Jeff Garzik <jeff@garzik.org>
>> Cc: Greg KH <gregkh@suse.de>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>>
>> ---
>>
>> diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
>> index 1f0b752..97171ad 100644
>> --- a/drivers/char/applicom.c
>> +++ b/drivers/char/applicom.c
>> @@ -65,7 +65,7 @@ static char *applicom_pci_devnames[] = {
>>      "PCI2000PFB"
>>  };
>>  
>> -static struct pci_device_id applicom_pci_tbl[] = {
>> +static struct pci_device_id applicom_pci_tbl[] __used = {
>>      { PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC,
>>        PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>>      { PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN,
> 
> I have probably a better fix with pci_match_id() referencing this array.

Hmm, checking it one more time persuades me that the best fix ever is to convert 
it to probing. David, do you have the card?
