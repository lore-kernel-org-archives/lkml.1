Return-Path: <linux-kernel-owner+w=401wt.eu-S933574AbZFLSeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbZFLSeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765854AbZFLSdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:33:54 -0400
Received: from claw.goop.org ([74.207.240.146]:40012 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765282AbZFLSdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:33:52 -0400
Message-ID: <4A329F8D.70906@goop.org>
Date: Fri, 12 Jun 2009 11:33:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
References: <4A329CF8.4050502@goop.org> <20090612192830.16224709@lxorguk.ukuu.org.uk>
In-Reply-To: <20090612192830.16224709@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/09 11:28, Alan Cox wrote:
>> +		if (error == -EINVAL) {
>> +			/*
>> +			 * The ACPI tables themselves were malformed.
>> +			 * Dell Precision Workstation 410, 610 come here.
>> +			 */
>> +			printk(KERN_ERR PREFIX
>> +			       "Invalid BIOS MADT, disabling ACPI\n");
>> +			disable_acpi();
>> +		} else {
>>      
>
> This seems a very bad model. On todays systems turning off ACPI renders
> them basically useless. If the MADT is bogus its far better to pray that
> they rest of the ACPI is mostly sound and continue by ignoring the only
> dodgy table.
>    

I didn't make any change there; I just preserved the original behaviour 
of stopping all ACPI parsing when it returned -EINVAL (with a slightly 
more helpful comment).  My change was to make it continue to the I/O 
APICs if it returned something else (ie, -ENODEV).

     J
