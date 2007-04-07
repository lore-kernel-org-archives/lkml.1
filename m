Return-Path: <linux-kernel-owner+w=401wt.eu-S966086AbXDGQcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966086AbXDGQcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966108AbXDGQcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:32:47 -0400
Received: from mail.tmr.com ([64.65.253.246]:60056 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966090AbXDGQco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:32:44 -0400
Message-ID: <4617C806.2030304@tmr.com>
Date: Sat, 07 Apr 2007 12:34:14 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, Ken Chen <kenchen@google.com>,
       Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] remove artificial software max_loop limit
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com> <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com> <Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr> <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com> <20070330141524.5f6cff29.akpm@linux-foundation.org> <460FE380.2050608@slax.org> <460FE478.9070901@slax.org> <b040c32a0704011110n639d6ea4h447646b6da92974e@mail.gmail.com> <Pine.LNX.4.61.0704012106010.16977@yvahk01.tjqt.qr>            <4616AE9C.9060400@tmr.com> <11158.1175962732@turing-police.cc.vt.edu>
In-Reply-To: <11158.1175962732@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Fri, 06 Apr 2007 16:33:32 EDT, Bill Davidsen said:
>   
>> Jan Engelhardt wrote:
>>     
>
>   
>>> Who cares if the user specifies max_loop=8 but still is able to open up 
>>> /dev/loop8, loop9, etc.? max_loop=X basically meant (at least to me) 
>>> "have at least X" loops ready.
>>>
>>>       
>> You have just come up with a really good reason not to do unlimited 
>> loops.
>>     
>
> That, and I'd expect the intuitive name for "have at least N ready" to
> be 'min_loop=N'.  'max_loop=N' means (to me, at least) "If I ask for N+1,
> something has obviously gone very wrong, so please shoot my process before
> it gets worse".
>
> Maybe what's needed is *both* a max_ and min_ parameter?
>   
I think that max_loop is a sufficient statement of the highest number of 
devices needed, and can reasonably interpreted as both "I may need this 
many" and "I won't legitimately want more."

As I recall memory is allocated as the device is set up, so unless you 
want to use the max memory at boot, "just in case," the minimum won't be 
guaranteed anyway. Something else could eat memory.

In practice I think asking for way too many is more common than not 
being able to get to the max. It may happen but it's a corner case, and 
status is returned.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

