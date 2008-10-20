Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbYJTQvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbYJTQvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYJTQvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:51:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45031 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYJTQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:51:00 -0400
Message-ID: <48FCB694.40901@zytor.com>
Date: Mon, 20 Oct 2008 09:49:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Roland Dreier <rdreier@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
References: <20081017171139.GA1792@elte.hu> <ada3aiv9k6j.fsf@cisco.com> <20081017180523.GA11590@elte.hu> <adatzbbrrcf.fsf@cisco.com> <20081017191202.GA5396@elte.hu> <adaiqrrrp2h.fsf@cisco.com> <20081018082209.GA24220@elte.hu> <alpine.LFD.2.00.0810200933470.3518@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810200933470.3518@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> The old code was correct. Your code is shit. And you didn't fix 
> _anything_.
> 
>>  	case 5:
>>  		*(int *)to = *(int *)from;
>> -		*((short *)to + 3) = *((short *)from + 3);
>> +		*((char *)(to + 3)) = *((char *)(from + 3));
>>  		return to;
> 
> Are you just making changes by randomly inserting and deleting characters 
> until you don't see warnings? Or what?
> 
> That thing is supposed to be a 5-byte memcpy. Not a "take a random byte 
> from a random location and move it to another random location". That would 
> be "randcpy()", not "memcpy()".
> 

That is not a 5-byte memcopy.  In *either* version!

In the "before" case, it copies bytes 0, 1, 2, 3, 6 and 7.
In the "after" case, it copies bytes 0, 1 and 2.

Presumably it *should* be:

	*((char *)to + 4) = *((char *)from + 4);

	-hpa
