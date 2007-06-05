Return-Path: <linux-kernel-owner+w=401wt.eu-S1763822AbXFEJSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763822AbXFEJSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761905AbXFEJSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:18:03 -0400
Received: from lmtp1.ucs.ed.ac.uk ([129.215.149.64]:57295 "EHLO
	lmtp1.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbXFEJSA (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:18:00 -0400
X-Greylist: delayed 2111 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2007 05:18:00 EDT
Date: Tue, 5 Jun 2007 09:42:46 +0100 (BST)
From: "James E. Jarvis" <jjarvis@staffmail.ed.ac.uk>
X-X-Sender: jjarvis@holyrood.ed.ac.uk
To: Robert Hancock <hancockr@shaw.ca>
cc: Linux-Kernel@vger.kernel.org,
       Kenneth MacDonald <kenneth.macdonald@ed.ac.uk>
Subject: Re: DMI_MATCH patch in reboot.c for SFF Dell OptiPlex 745 - fixes
 hang on reboot
In-Reply-To: <4664B306.5000107@shaw.ca>
Message-ID: <Pine.GSO.4.64.0706050918350.24899@holyrood.ed.ac.uk>
References: <fa./cH7AY3hv2QMikoTK1P7fAVvbdI@ifi.uio.no> <4664B306.5000107@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Edinburgh-Scanned: at lmtp1.ucs.ed.ac.uk
    with MIMEDefang 2.52, Sophie, Sophos Anti-Virus
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Robert Hancock wrote:

> James Jarvis wrote:
>> I trust this is the right list...
>> 
>> The following patch enables reboot through BIOS on the Dell Optiplex 745 
>> Small Form Factor base, on which reboot hangs. The larger form factor does 
>> not require this, hence the match on DMI_BOARD_NAME.
>> 
>> --- arch/i386/kernel/reboot.c.orig      2007-06-01 12:22:53.000000000 
>> +0100
>> +++ arch/i386/kernel/reboot.c   2007-06-04 16:53:36.000000000 +0100
>> @@ -104,6 +104,15 @@
>>                        DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 300/"),
>>                },
>>        },
>> +       {       /* Handle problems with rebooting on Dell Optiplex 745's 
>> SFF*/
>> +               .callback = set_bios_reboot,
>> +               .ident = "Dell OptiPlex 745",
>> +               .matches = {
>> +                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
>> +                       DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
>> +                       DMI_MATCH(DMI_BOARD_NAME, "0WF810"),
>> +               },
>> +       },
>>        {       /* Handle problems with rebooting on Dell 2400's */
>>                .callback = set_bios_reboot,
>>                .ident = "Dell PowerEdge 2400",
>
> This blacklist seems to be growing. Isn't there something better we can do 
> here? Can we just reboot through the BIOS by default, is that really broken 
> on some systems?

Agreed, it is ugly. However I don't like leavng the determination of 
whether the system board will only reboot through BIOS to the end user. 
Whilst using the kernel boot argument "reboot=b" is an alternative, it 
works only _if_ one knows the platform in advance. However our boot media 
(and indeed live-cds generally) are used such that this is not practical.

As for whether rebooting through BIOS by default would solve this matter - 
I don't know. It may break on some machines. Given that EFI may (???) 
replace traditional BIOS in the future is it worth re-engineering this?

James Jarvis
Uinversity of Edinburgh
