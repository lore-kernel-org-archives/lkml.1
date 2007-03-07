Return-Path: <linux-kernel-owner+w=401wt.eu-S1161105AbXCGHO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161105AbXCGHO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161106AbXCGHO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:14:26 -0500
Received: from terminus.zytor.com ([192.83.249.54]:52690 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161105AbXCGHOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:14:25 -0500
Message-ID: <45EE662D.4010701@zytor.com>
Date: Tue, 06 Mar 2007 23:13:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703060917500.5963@woody.linux-foundation.org> <200703061828.00253.dada1@cosmosbay.com> <200703061910.13431.dada1@cosmosbay.com> <45EDCD11.8070000@cosmosbay.com> <Pine.LNX.4.64.0703061944590.5963@woody.linux-foundation.org> <45EE624A.8040407@cosmosbay.com>
In-Reply-To: <45EE624A.8040407@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Linus Torvalds a écrit :
>>
>> On Tue, 6 Mar 2007, Eric Dumazet wrote:
>>> I did a user space program, attached to this mail.
>>>
>>> I rewrote the reciprocal_div() for i386 so that one multiply is used.
>>
>> Ok, this is definitely faster on Core 2 as well, so "numbers talk, 
>> bullshit walks". No more objections.
> 
> And the numbers were ? :)
> 
>>
>> (That said, I bet you could do even better for octal and hex numbers, 
>> so if you *really* want to speed things up, you should just make a 
>> special-case routine for each base (there's just three of them), and 
>> you can then also optimize the base-10 thing much better (you can do 
>> two digits at a time by dividing by 100, etc)
> 
> Well, given that sprintf() is frequently called only for pipe/sockets 
> creation, we probably better :
> 
> 1) wait a very clever idea to suppress individual dentry per 
> pipe/sockets (no more sprintf() at pipe/socket setup)
> 
> 2) delay the sprintf() only if needed as you mentioned in a previous 
> mail (when someone wants ls -l /proc/pid/fd/....), since their dentries 
> are not anymore inserted in the global dcache hash, they could stay with 
> a (nul) dname.

Yes, the right thing to do is probably to only generate these strings 
when someone tries to list them, not on every socket/pipe/epoll 
creation.  One can assign a counter and keep it as a binary value at the 
start, but create the strings when necessary.

	-hpa

