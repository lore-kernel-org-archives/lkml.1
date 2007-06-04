Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXFDOfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXFDOfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbXFDOfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:35:36 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:20896 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbXFDOff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:35:35 -0400
Date: Mon, 04 Jun 2007 08:35:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH -mm] 1/2: MMCONFIG: validate against ACPI motherboard
 resources
In-reply-to: <20070604121250.GA33621@dspnet.fr.eu.org>
To: Olivier Galibert <galibert@pobox.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-id: <4664231A.2040703@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <465CF794.1070406@shaw.ca> <20070604121250.GA33621@dspnet.fr.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert wrote:
> On Tue, May 29, 2007 at 10:03:32PM -0600, Robert Hancock wrote:
>> -Validate that the area is reserved even if we read it from the
>> chipset directly and not from the MCFG table. This catches the case
>> where the BIOS didn't set the location properly in the chipset and
>> has mapped it over other things it shouldn't have.
> 
> Just for the record, I still fundamentally disagree with that part.
> You're not catching what you think you're catching, since the chipset
> tells you what it is going to decode as mmconfig, no matter what is
> connected to it.

But we don't - not in the case where it's overlapped some other area 
with the MMCONFIG region. We saw a case of this on some of the Intel 
boards, where the MMCONFIG is a 128MB area at 0xf0000000, and when 
sizing the BARs on a PCI Express video device with a 256MB region, it 
ended up being located momentarily at f0000000-ffffffff, which 
overlapped the MMCONFIG area. That caused MMCONFIG to stop working, so 
apparently on that chipset, PCI Express devices connected to the 
northbridge have a higher decode priority than the MMCONFIG area.

If the BIOS is so screwed up that this becomes an issue, I don't think 
we can sanely try to use the table, since we can't anticipate all the 
potential problems that might result.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

