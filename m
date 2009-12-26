Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZLZPkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZLZPkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 10:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZLZPkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 10:40:42 -0500
Received: from mail-pz0-f198.google.com ([209.85.222.198]:36996 "EHLO
	mail-pz0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZLZPkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 10:40:41 -0500
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Dec 2009 10:40:41 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HLXoy9pa8ftQ8WlXUG/ILa3BKAwr/5ZODE1oiU8nNs5WSVBGjRCKAOMgST3oeqs6S1
         RJ/dwgZHam5nX5yt4R64yjkgghg2hD2W81vRybOuU2+67ZadNUeQxPUAOA2CagalWkLK
         35G5uAvEv2HRJXNIlb0h7PBthUvfF7KY9tjyM=
Message-ID: <4B362C95.4040700@lwfinger.net>
Date: Sat, 26 Dec 2009 09:32:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: Regression in module wmi since 2.6.32 (bisected to commit 1caab3c)
References: <4B352513.90302@lwfinger.net> <200912252158.31127.carlos@strangeworlds.co.uk> <4B353818.1020308@lwfinger.net> <200912260118.26391.carlos@strangeworlds.co.uk>
In-Reply-To: <200912260118.26391.carlos@strangeworlds.co.uk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2009 07:18 PM, Carlos Corbacho wrote:
> On Friday 25 December 2009 22:09:28 Larry Finger wrote:
>> On 12/25/2009 03:58 PM, Carlos Corbacho wrote:
>>> On Friday 25 December 2009 21:35:49 Larry Finger wrote:
>>>> Should I attach the files DSDT.dat, acpidump.out, or DSDT?
>>>
>>> DSDT from /proc/acpi/dsdt will do fine for my purposes.
>>
>> Attached.
> 
> This is the same as bugzilla #14846 - in both cases, the GUID 05901221-D566-11D1-B2F0-00A0C9062910 (a data block query) is duplicated in two different devices, although both look like they are nVidia related hooks.
> 
> Since we don't currently have any in kernel drivers that use that stuff, and the query in question just returns a binary MOF, the simplest solution (for now) seems to be to just ignore these duplicates - if and when someone wants to support these hooks, they can clean the mess up properly when they figure out how WMI is supposed to cope with conflicting GUID's. 
> 
> Matthew, you looked at NVIF for your sins, can you see a better solution? We could just blacklist the offending GUID, rather than trying to catch all duplicates? Although just ignoring all duplicates strikes me as a better solution to catch the next time that J Random BIOS Developer decides to duplicate GUIDs in WMI.
> 
> Initial patch below which takes the "ignore all duplicate GUIDs" approach.

The patch fixes my machine.

Thanks,

Larry

