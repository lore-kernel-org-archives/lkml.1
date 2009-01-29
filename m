Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbZA2XT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbZA2XT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZA2XTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:19:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41861 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZA2XTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:19:50 -0500
Message-ID: <4982398D.1020506@zytor.com>
Date: Thu, 29 Jan 2009 15:19:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: RFC: running out of x86 boot loader IDs
References: <49823683.6060201@zytor.com> <20090129231641.GC29611@elte.hu>
In-Reply-To: <20090129231641.GC29611@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>
>> - If the boot loader ID is E, the current pad1 field at 0x226 is  
>> repurposed as an extended loader ID.  The reason to use the pad1 field  
>> is that it is present in all headers since version 2.02.  The boot  
>> loader ID will simply be: ((extended ID + 0x10) << 4) + (version), where  
>> (version) as before is (type_of_loader & 15).  This is the value which  
>> will be reported in /proc/sys/kernel/bootloader_type.
>>
>> The biggest question is probably: is there a need/desire for an extended 
>> version field, or is four bits enough for existing bootloader needs?
> 
> i think it's prudent to add an extension mechanism, regardless of demand. 
> Existing bootloader projects will be content with the IDs they already 
> have so they are unlikely to request new ones. Future bootloader projects 
> cannot request it because they dont exist yet. So there's no-one to talk 
> up.
> 

Good point.  If so, it probably makes most sense to split pad1 into two 
one-byte fields; one for ID and one for version.  The bootloader_type 
will have to continue to be (ID << 4)+basic_version; we can presumably 
add a bootloader_version file which can report a bigger ID.

Either that or we can expose the raw pad1 field as bootloader_exttype 
and force any users to be aware of the field splits.

	-hpa

