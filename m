Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYJYRLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYJYRLE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 13:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYJYRKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 13:10:53 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:24802 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYJYRKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 13:10:52 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=7_tdhnrDAAAA:8 a=VwQbUJbxAAAA:8 a=nCgkYOTl5xLp-_XF780A:9 a=-5PjfjfUUVv2rmBsOnnIbDzh4vkA:4 a=vrkRlL--0JAA:10 a=SbpR8sHSqxIA:10
Message-ID: <49035313.9080309@shaw.ca>
Date: Sat, 25 Oct 2008 11:10:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, lenb@kernel.org, fabio.comolli@gmail.com
Subject: Re: [Re: Linux 2.6.28-rc1] ACPI Warning (nspredef-0852)[...]
References: <fa.1HaqObZirROiyqr922A7hRDVc54@ifi.uio.no> <fa.SvX6X2rOJRj5l1wwqyz6iNq7qHU@ifi.uio.no> <fa.Rzh43vSl9NX1QQ2nOYQSgEJcZAw@ifi.uio.no>
In-Reply-To: <fa.Rzh43vSl9NX1QQ2nOYQSgEJcZAw@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Sat, 25 Oct 2008, Rafael J. Wysocki wrote:
>> On Saturday, 25 of October 2008, Maciej Rutecki wrote:
>>> During suspend to ram I have this message:
>>>
>>> ACPI Warning (nspredef-0852): \_WAK: Return type mismatch - found
>>> Integer, expected Package [20080926]
>>>
>>> s2ram seems works OK
>>>
>>> dmesg, acpidump:
>>> http://unixy.pl/maciek/download/kernel/2.6.28-rc1_wak/
>> IMO it's yet another incarnation of
>> http://bugzilla.kernel.org/show_bug.cgi?id=11822
> 
> If this is an outright violation of the ACPI spec, let me know (and if
> possible, please tell me the spec page).  This is the kind of thing I expect
> it would be a no-brainer to get Lenovo to fix with a BIOS update.

I don't think this is the same issue, but in both cases it looks like 
the BIOS AML code is wrong (just judging from the output, haven't looked 
at the dump yet). _WAK is supposed to return a package of 2 DWORD 
values, a bit field of conditions that occurred during sleep, and the 
effective S-state the system actually entered (section 7.3.7 of the ACPI 
3.0 spec). Presumably the BIOS is returning a single integer.
