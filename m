Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYCST1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYCST1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYCSTZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:25:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36342 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYCSTZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:25:10 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E0D9A7.1040308@s5r6.in-berlin.de>
Date: Wed, 19 Mar 2008 10:15:19 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Adrian Bunk <bunk@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
References: <200803110014.52985.rjw@sisk.pl> <47D67992.8010308@s5r6.in-berlin.de> <20080311130449.GA21157@cs181133002.pp.htv.fi> <47DEE282.8060904@m3y3r.de>
In-Reply-To: <47DEE282.8060904@m3y3r.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> Adrian Bunk schrieb:
>> On Tue, Mar 11, 2008 at 01:22:42PM +0100, Stefan Richter wrote:
>>  
>>> Rafael J. Wysocki wrote:
>>>    
>>>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=10080

I have reopened, re-assigned, and slightly renamed that bug now.

>>>> Subject        : 2.6.25-rc2: ohci1394 problem
>>>> Submitter    : Thomas Meyer <thomas@m3y3r.de>
>>>> Date        : 2008-02-20 08:47
>>>> References    : http://lkml.org/lkml/2008/2/20/58
>>>> Handled-By    : Stefan Richter <stefanr@s5r6.in-berlin.de>

This bug is not handled by me.

>>>>       
>>> Thomas wrote on 2008-02-25:
>>> ''So i did a "make clean" and a "make" (not a make
>>> -j3 as i use to do) and recompiled 2.6.25-rc3 and now it works again.
>>> Case closed under strange error.''
>>> ...
>>>     
>>
>> Although I don't think this would cause the error, it would be nice if 
>> Thomas could verify that the -j3 did not cause the problem.
>>   
> I still cannot *believe* this bug, but  i just checked out the latest 
> kernel and did a make distclean and a make (with mr. bunks patch 
> applied) and there it is again:
> $ dmesg
> 
> (cut)
> [  464.852986] ohci1394: fw-host0: physical posted write error
[...]
> [  464.898957] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
> and so on....
> 
> $ git describe
> v2.6.25-rc6-14-gbde4f8f
> 
> As i already wrote: I tried to bisect this behavior, but with no result.
> 
> And Stefan didn't change anything in the involved drivers. I have no 
> idea what could cause this kind of bug!

The messages which Thomas posted result from ohci1394 getting ~0 (i.e. 
0xffffffff) from some or all MMIO reads.  This is not a FireWire driver bug.

MMIO has been broken by something after 2.6.24.
-- 
Stefan Richter
-=====-==--- --== =--==
http://arcgraph.de/sr/
