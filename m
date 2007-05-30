Return-Path: <linux-kernel-owner+w=401wt.eu-S1759712AbXE3WEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbXE3WEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbXE3WEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:04:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18384 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbXE3WEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:04:45 -0400
Message-ID: <465DF49B.7040100@oracle.com>
Date: Wed, 30 May 2007 15:03:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hugh@veritas.com
Subject: Re: [PATCH 1/3] hexdump: more output formatting
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>	 <Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>	 <20070523182145.7d7f1f7e.randy.dunlap@oracle.com>	 <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>	 <20070524073131.GA17501@elte.hu>	 <Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>	 <20070524142908.f39f42ea.akpm@linux-foundation.org>	 <20070524145517.1f32cd94.randy.dunlap@oracle.com>	 <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>	 <20070530143428.2f20446a.randy.dunlap@oracle.com> <a781481a0705301456n246e7185ife2a144eae3179b3@mail.gmail.com>
In-Reply-To: <a781481a0705301456n246e7185ife2a144eae3179b3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Hello Randy,
> 
>> Add a prefix string parameter.  Callers are responsible for any
>> string length/alignment that they want to see in the output.  I.e.,
>> callers should pad strings to achieve alignment if they want that.
>>
>> Add rowsize parameter.  This is the number of raw data bytes
>> to be printed per line.  Must be 16 or 32.
>>
>> Add a group_size parameter.  This allows callers to dump values
>> as 1-byte, 2-byte, 4-byte, or 8-byte numbers.  Default is
>> 1-byte numbers.  If the total length is not an even multiple
>> of group_size, 1-byte numbers are printed.
> 
> I wonder if (over-)engineering could hurt its adoption by more kernel
> users. There aren't very many 8-argument monsters in the kernel,
> and one would expect hexdump() to be easier on the fingers to
> type? :-) Why not just continue with reasonable default/fixed rowsize
> and groupsize values?

Yes, one can try to satisfy the users/callers by adapting to their
needs (wishes), which requires parameters or such; or one can have
no callers and end up with (around 11 currently) different hex dump
functions in the kernel source tree, but no users of lib/hexdump.c.

But it won't take much more "requirements" for me to drop the patch.

>> Add an "ascii" output parameter.  This causes ASCII data output
>> following the hex data output.
> [...]
>> +       if (!ascii)
>> +               goto nil;
>> +
>> +       if ((lx + 1) < linebuflen)
>>                 linebuf[lx++] = ' ';
>> -       }
>> -       for (j = 0; (j < 16) && (j < len) && (lx + 2) < linebuflen; j++)
>> +       for (j = 0; (j < rowsize) && (j < len) && (lx + 2) < 
>> linebuflen; j++)
>>                 linebuf[lx++] = isprint(ptr[j]) ? ptr[j] : '.';
>> +nil:
>>         linebuf[lx++] = '\0';
> 
> if (ascii) {
> ...
> }
> 
> linebuf[lx++] = '\0';
> 
> would help lose a goto and label.

The label has another reference already, so it wouldn't be lost.

But the if (ascii) block could be added...

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
