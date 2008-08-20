Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbYHTV4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbYHTV4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYHTV4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:56:10 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:34009 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbYHTV4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:56:09 -0400
Message-ID: <48AC921D.7050201@cs.columbia.edu>
Date: Wed, 20 Aug 2008 17:52:29 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, Theodore Tso <tytso@mit.edu>,
       Daniel Lezcano <daniel.lezcano@fr.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: checkpoint/restart ABI
References: <20080807224033.FFB3A2C1@kernel>		<200808090013.41999.arnd@arndb.de>	<20080811152201.GB25930@us.ibm.com>		<200808111853.13854.arnd@arndb.de>	<1218484114.5598.43.camel@nimitz>	 <48A0CD86.6030704@goop.org>	<1218553091.5598.76.camel@nimitz>	 <48A1BB39.3090108@goop.org>	<1218559619.5598.97.camel@nimitz> <48A1C2B9.9070107@goop.org>
In-Reply-To: <48A1C2B9.9070107@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jeremy Fitzhardinge wrote:
> Dave Hansen wrote:
>>>> I'm not sure what you mean by "closed files".  Either the app has a fd,
>>>> it doesn't, or it is in sys_open() somewhere.  We have to get the app
>>>> into a quiescent state before we can checkpoint, so we basically just
>>>> say that we won't checkpoint things that are *in* the kernel.
>>>>       
>>> It's common for an app to write a tmp file, close it, and then open it a 
>>> bit later expecting to find the content it just wrote.  If you 
>>> checkpoint-kill it in the interim, reboot (clearing out /tmp) and then 
>>> resume, then it will lose its tmp file.  There's no explicit connection 
>>> between the process and its potential working set of files.
>>>     
>> I respectfully disagree.  The number one prerequisite for
>> checkpoint/restart is isolation.  Xen just happens to get this for free.
>>   
> 
> (I don't have my Xen hat on at all for this thread.)
> 
>> So, instead of saying that there's no explicit connection between the
>> process and its working set, ask yourself how we make a connection.
>>
>> In this case, we can do it with a filesystem (mount) namespace.  Each
>> container that we might want to checkpoint must have its writable
>> filesystems contained to a private set that are not shared with other
>> containers.  Things like union mounts would help here, but aren't
>> necessarily required.  They just make it more efficient.
>>   
> 
> We were dealing with checkpointing random sets of processes, and that 
> posed all sorts of problems.  Filesystem namespace was one, the pid 
> namespace was another.  Doing checkpointing at the container-level 
> granularity definitely solves a lot of problems.
> 
>>>> Is there anything specific you are thinking of that particularly worries
>>>> you?  I could write pages on the list you have there.
>>>>       
>>> No, that's the problem; it all worries me.  It's a big problem space.
>>>     
>> It's almost as big of a problem as trying to virtualize entire machines
>> and expecting them to run as fast as native. :)
>>   
> 
> No, it's much harder.  Hardware is relatively simple and immutable 
> compared to kernel and process state ;)
> 
>> Cool!  I didn't know you guys did the IRIX implementation.  I'm sure you
>> guys got a lot farther than any of us are.  Did you guys ever write any
>> papers or anything on it?  I'd be interested in more information.
>>   
> 
> Yeah, there was a paper, but it looks like the internet has lost it.  It 
> was at 
> http://www.csu.edu.au/special/conference/apwww95/.papers95/cmaltby/cmaltby.ps
> http://www.csu.edu.au/special/conference/apwww95/sept-all.html has 
> mention of the paper.
> 

you can find it here:

http://ertos.nicta.com.au/publications/papers/Maltby_Chubb_95.pdf

Oren.

