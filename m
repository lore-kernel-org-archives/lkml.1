Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbYDOSyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbYDOSyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYDOSyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:54:08 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:52713 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYDOSyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:54:07 -0400
Message-ID: <4804F971.3020207@cs.columbia.edu>
Date: Tue, 15 Apr 2008 14:52:33 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Nadia Derbey <Nadia.Derbey@bull.net>
CC: Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [RFC][PATCH 0/4] Object creation with a specified id
References: <20080404145129.637145000@bull.net> <20080415030623.GA8171@tull.net> <480483C2.3030509@bull.net>
In-Reply-To: <480483C2.3030509@bull.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Nadia Derbey wrote:
> Nick Andrew wrote:
>> On Fri, Apr 04, 2008 at 04:51:29PM +0200, Nadia.Derbey@bull.net wrote:
>>
>>>   . echo "LONG XX" > /proc/self/next_id
>>>     next object to be created will have an id set to XX
>>>   . echo "LONG<n> X0 ... X<n-1>" > /proc/self/next_id
>>>     next object to be created will have its ids set to XX0, ... X<n-1>
>>>     This is particularly useful for processes that may have several 
>>> ids if
>>>     they belong to nested namespaces.
>>
>>
>> How do you handle race conditions, i.e. you specify the ID for the
>> next object to be created, and then some other thread goes and creates
>> an object before your thread creates one?
>>
>> Nick.
> 
> 
> Sorry for not answering earlier, I just saw your e-mail!

[I too managed to miss that message].

> 
> It's true that the way I've done things, the "create_with_id" doesn't 
> take into account multi-threaded apps, since "self" is related to the 
> thread group leader.
> 
> May be using something like /proc/self/task/<my_tid>/next_id would be 
> better, but I have to think more about it...

That /proc/self links to /proc/TGID slipped my mind. Definitely must
be done on a per-thread basis (and /proc/<TGID>/task/<PID>/next_id
will do the trick).

Oren.

> 
> Regards,
> Nadia
