Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZAKACv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZAKACv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 19:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZAKACo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 19:02:44 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:61661 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbZAKACn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 19:02:43 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=YICcMnqQNrm_KWALp6kA:9 a=scXzXu0Nw1q3cp2GPAYA:7 a=GxPVq-lANq1naoWoVOm4jSIKKPQA:4 a=M-ExZQ-wgAMA:10 a=dXD_W6XKJooA:10
Message-ID: <49693720.5010707@shaw.ca>
Date: Sat, 10 Jan 2009 18:02:40 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN
   (4)
References: <49683957.9070700@gmail.com> <49685B70.8080908@shaw.ca> <4968CB72.6080100@gmail.com>
In-Reply-To: <4968CB72.6080100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> Robert Hancock wrote:
>> Justin P. Mattock wrote:
>>> I am seeing this in dmesg:
>>> FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
>>> not sure what this is.
>>> (the only changes to .config was add kexec,
>>> coredump, and relocatable kernel options.)
>>>
>>> I take it that I'm unable to try this relocatable
>>> kernel stuff out.(x86_32)?
>>>
>>> regards;
>>>
>>> Justin P. Mattock
>>
>> I believe that indicates your BIOS's FADT table contains inconsistent 
>> data. You're sure that only happens with those options set?
>>
> Well, the positive side is kexec
> does work on  macbook pro
> (doesn't play so well with the xserver,
> garbled screen.).
> 
> As for the FADT table, I reverted to an old
> .config that has no new options in it, and sure enough
> that message appeared. Looking back in my logs,
> the last kernel commit I have is:
> 2.6.28-07485-g9e42d0c
> that doesn't show such messages.
> 
> When examining this message
> (not too familiar with FADT)
> I see PM leading me to believe this maybe has to
> do with the PM stuff.
> (making me wonder, if this is the reason
> suspend isn't working.just a black screen
> upon wakeup); but like I said I'm not
> familiar with that area.

According to the code comments in drivers/acpi/acpica/tbfadt.c:

  * The PM event blocks are split into two register blocks, first is the
  * PM Status Register block, followed immediately by the PM Enable
  * Register block. Each is of length (xpm1x_event_block.bit_width/2).
  *
  * On various systems the v2 fields (and particularly the bit widths)
  * cannot be relied upon, though. Hence resort to using the v1 length
  * here (and warn about the inconsistency).

So it looks like it's fixing things up, so it's not really a problem, 
just warning about busted BIOS tables. Not impossible it's related to 
the resume problem, but wouldn't be the first thing I'd look at..
