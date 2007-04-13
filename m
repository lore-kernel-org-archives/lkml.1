Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbXDMCym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbXDMCym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbXDMCym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:54:42 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:42405 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753086AbXDMCyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:54:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=dXZab97v8DXVNXquMZw+WForqLKBG8Dn/zxaiK2u+A97HzWFrSxgyD6g2+M8WZVrCiCbtscXiGRXQXF7s9cvvbA9czQuBoc/yvSCObCG2vZ07gEK80EEjiecY/xECiUrXGdh5IjeBIvo+nNC7DHNS6hJtAJjTNdzJ9GJl/N81jg=  ;
X-YMail-OSG: fHaloncVM1kvVT0IJ1_r5iFWYAFMU6oRvRlZ8LkC59T_mC5T2tn5RvaDRFoVLPmhJR2dBULgXQ--
Message-ID: <461EF0EC.4090908@yahoo.com.au>
Date: Fri, 13 Apr 2007 12:54:36 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070413015712.GL11115@waste.org> <461EE925.1000301@yahoo.com.au> <20070413022345.GN11115@waste.org>
In-Reply-To: <20070413022345.GN11115@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Fri, Apr 13, 2007 at 12:21:25PM +1000, Nick Piggin wrote:
> 
>>Matt Mackall wrote:
>>
>>>On Fri, Apr 13, 2007 at 11:42:29AM +1000, Nick Piggin wrote:
>>
>>>>If kprobes is simply crappy and doesn't work properly for this, then I
>>>>could accept that. I'm not someone trying to get this info. So why can't
>>>>it be used? (not just for kpagemap, but for clear_refs and all that gunk
>>>>too).
>>>
>>>
>>>kprobes is good for looking at events, but bad for looking at state.
>>>Especially metric shitloads of state.
>>
>>Why? Why is a kprobes trap significantly more expensive than a read
>>syscall?
> 
> 
> I guess I'm not clear on what you're proposing. From my understanding
> of kprobes (admittedly not an expert), this is hard to do and not a
> very good match.

But you have an idea that it is bad for exposing lots of data. Why?
(I'm not a kprobes expert either, these are not rhetorical questions)

 From what it looks like, you can traverse data structures and copy data
back to userspace. Which is what makes me think it might be suitable
(or could be made suitable).


>>>>Maybe. How about LRU? Reclaim performance is bad, and you want to work out
>>>>which pages keep going off the end of it, or which pages keep getting
>>>>written out via it, or who's pages are on the active list, forcing mine
>>>>out.
>>>
>>>
>>>Those are actually probably a good match for systemtap as they're all 
>>>events.
>>
>>Traverse the LRU? Which files do they belong to? What process maps them?
> 
> 
> -ENOPARSE.

Basically, any "stuff" other than what you're exposing.

-- 
SUSE Labs, Novell Inc.
