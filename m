Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbZBXVj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbZBXVj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbZBXVjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:39:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:43115 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbZBXVjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:39:46 -0500
Message-ID: <49A468E2.4040308@kernel.org>
Date: Tue, 24 Feb 2009 13:38:42 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Jourdan <tjourdan@interfaceconcept.com>,
       linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
       Peter Jones <pjones@redhat.com>
Subject: Re: [BUG] dmi_scan_machine uses uninitialized address on x86 / EFI
References: <342F93DAA55A4EE888FBD256CE6044F4@thje6600v> <49A462BD.7010205@zytor.com>
In-Reply-To: <49A462BD.7010205@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Thomas Jourdan wrote:
>> On x86/EFI platforms, if efi_enabled is true, the dmi_scan_machine function
>> fails, even if valid DMI table is present. In the setup_arch function,
>> efi_init is called after dmi_scan_machine. But this is efi_init which will
>> initialize the smbios address, needed by dmi_scan_machine.
>>
>> This leads to dmi_scan_machine ioremapping physical address 0, instead of
>> the address provided by the EFI system table. The following patch fixes the
>> problem.
>>
> 
> Hi Thomas,
> 
> What is the concrete manifestation of the bug (i.e. how critical is it?)
>  We are late in the 2.6.29-rc cycle, and this patch seems to have some
> risk associated with it.
> 
> Huang, Peter, Yinghai: any opinions?
> 
should be ok for 2.6.29

YH
