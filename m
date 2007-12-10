Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbXLJDU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbXLJDU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 22:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXLJDUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 22:20:15 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:63005 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbXLJDUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 22:20:12 -0500
Date: Sun, 09 Dec 2007 21:20:09 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
In-reply-to: <475CA388.9050805@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Message-id: <475CB069.3050001@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.qQhD8aJpiTOFaZqjRYwoaG7YT1c@ifi.uio.no>
 <fa.yaP86AixGhz5Q7eXSu04pIQp6ho@ifi.uio.no>
 <fa.c3k8VKWAx4HIo9zXWbL5Ek0oSBw@ifi.uio.no>
 <fa.C8ACnOhs8bXB++vmugf5F34JcJg@ifi.uio.no>
 <fa.5o6E6S0UWnARbQPxLe30TvLQIiY@ifi.uio.no> <475AE150.9050306@shaw.ca>
 <20071209213642.GA27096@rhlx01.hs-esslingen.de>
 <20071210000429.GA3916@rhlx01.hs-esslingen.de>
 <20071210004959.GA23280@rhlx01.hs-esslingen.de> <475C9643.2000202@shaw.ca>
 <475CA388.9050805@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Robert Hancock wrote:
>> And you're quite right in your comment that we are often too quick to
>> blacklist hardware instead of looking into why it really is failing.
>> ACPI is one of those areas where we often just need to figure out how to
>> be bug-to-bug compatibile with what Windows is doing..
> 
> In the spirit of not blacklisting without looking deep into ACPI code,
> can somebody familiar with ASL take a look at comment 11 of bug 9320?
> 
>   http://bugzilla.kernel.org/show_bug.cgi?id=9320#c11
> 
> This is libata calling _GTM to find out how the BIOS configured the
> device to determine cable type.
> 
> Thanks.

I suspect it's somewhat similar (though perhaps a different cause), the 
code is trying to lookup a value (presumably register contents) in a 
table using Match, gets a value that's not in the table (which makes 
Match return the ONES value FFFFFFFF meaning not found) and so the 
lookup of the corresponding output value with that index fails. We'd 
need the full ASL dump to know exactly what's going on there.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

