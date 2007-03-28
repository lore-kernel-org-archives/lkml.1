Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbXC1JSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbXC1JSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 05:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbXC1JSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 05:18:45 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:58807 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXC1JSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 05:18:44 -0400
Message-ID: <460A32DD.20003@in.ibm.com>
Date: Wed, 28 Mar 2007 14:48:21 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Dave Hansen <hansendc@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       menage@google.com, xemul@sw.ru, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: controlling mmap()'d vs read/write() pages
References: <m1mz2enh0u.fsf@ebiederm.dsl.xmission.com> <1174062660.8184.8.camel@localhost.localdomain> <m1tzwlm33i.fsf@ebiederm.dsl.xmission.com> <1174074412.8184.29.camel@localhost.localdomain> <m1zm6ajvns.fsf@ebiederm.dsl.xmission.com> <1174407335.26166.146.camel@localhost.localdomain> <m13b3zmx4b.fsf@ebiederm.dsl.xmission.com> <46036C54.6030502@yahoo.com.au> <m1tzwc5kw6.fsf@ebiederm.dsl.xmission.com> <1174668073.8323.63.camel@localhost.localdomain> <20070323181626.GA17007@MAIL.13thfloor.at>
In-Reply-To: <20070323181626.GA17007@MAIL.13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Poetzl wrote:
>> To me, one of the keys of Linux's "global optimizations" is being able
>> to use any memory globally for its most effective purpose, globally
>> (please ignore highmem :).  Let's say I have a 1GB container on a
>> machine that is at least 100% committed.  I mmap() a 1GB file and touch
>> the entire thing (I never touch it again).  I then go open another 1GB
>> file and r/w to it until the end of time.  I'm at or below my RSS limit,
>> but that 1GB of RAM could surely be better used for the second file.
>> How do we do this if we only account for a user's RSS?  Does this fit
>> into Alan's unfair bucket? ;)
> 
> what's the difference to a normal Linux system here?
> when low on memory, the system will reclaim pages, and
> guess what pages will be reclaimed first ...
> 

But would it not bias application writers towards using read()/write()
calls over mmap()? They know that their calls are likely to be faster
when the application is run in a container. Without page cache control
we'll end up creating an asymmetrical container, where certain usage is 
charged and some usage is not.

Also, please note that when a page is unmapped and moved to swap cache;
the swap cache uses the page cache. Without page cache control, we could
end up with too many pages moving over to the swap cache and still
occupying memory, while the original intension was to avoid this
scenario.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
