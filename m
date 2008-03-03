Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbYCCRxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbYCCRxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbYCCRxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:53:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44088 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYCCRxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:53:41 -0500
Message-ID: <47CC3AFD.5070308@zytor.com>
Date: Mon, 03 Mar 2008 09:53:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Klaus S. Madsen" <ksm@hjernemadsen.org>, Pavel Machek <pavel@ucw.cz>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
References: <20080228192404.GH17932@hjernemadsen.org> <47C70C01.4020605@zytor.com> <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu>
In-Reply-To: <20080303174858.GB25496@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Klaus S. Madsen <ksm@hjernemadsen.org> wrote:
> 
>> The following patch solves the segfault, by changing the mmap flags of 
>> the video memory area, to allow execution. The patch is against 
>> libx86-0.99 available from http://www.codon.org.uk/~mjg59/libx86/
>>
>> --- libx86-0.99/x86-common.c	2006-09-08 00:44:27.000000000 +0200
>> +++ libx86-0.99.new/x86-common.c	2008-03-01 10:08:25.000000000 +0100
>> @@ -232,7 +232,7 @@
>>  	}
>>  
>>  	m = mmap((void *)0xa0000, 0x100000 - 0xa0000,
>> -	 PROT_READ | PROT_WRITE,
>> +	 PROT_READ | PROT_WRITE | PROT_EXEC,
> 
> are you sure you ID-ed the right commit that broke things?
> 
> while requiring PROT_EXEC is fine, breaking existing user-space apps 
> over that is not fine. So are you absolutely sure that by reverting that 
> PWT|PCD commit, s2ram again starts to work? That's utmost weird...
> 
> perhaps there's some CPU bug that causes NX to _NOT_ work if only PCD is 
> used (not PCD|PWT). Seems like a pretty unlikely scenario though.
> 

It really does.  What would be much more likely is that the PCD -> 
(PCD|PWT) triggered something in the kernel proper.

	-hpa
