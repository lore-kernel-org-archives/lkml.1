Return-Path: <linux-kernel-owner+w=401wt.eu-S2992876AbXDFBD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992876AbXDFBD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 21:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992877AbXDFBD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 21:03:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992876AbXDFBD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 21:03:57 -0400
Message-ID: <46159C71.3060708@redhat.com>
Date: Thu, 05 Apr 2007 21:03:45 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org> <46159987.6090006@redhat.com>
In-Reply-To: <46159987.6090006@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Linus Torvalds wrote:
>>
>> On Thu, 5 Apr 2007, Robin Holt wrote:
>>> For testing, Jack Steiner create the following patch.  All it does
>>> is moves tasks which are transitioning to the zombie state from where
>>> they are in the children list to the head of the list.  In this way,
>>> they will be the first found and reaping does speed up.  We will still
>>> do a full scan of the list once the rearranged tasks are all removed.
>>> This does not seem to be a significant problem.
>>
>> I'd almost prefer to just put the zombie children on a separate list. 
>> I wonder how painful that would be..
>>
>> That would still make it expensive for people who use WUNTRACED to get 
>> stopped children (since they'd have to look at all lists), but maybe 
>> that's not a big deal.
> 
> Shouldn't be any worse than it already is.
> 
>> Another thing we could do is to just make sure that kernel threads 
>> simply don't end up as children of init. That whole thing is silly, 
>> they're really not children of the user-space init anyway. Comments?
>>
>>         Linus
> 
> Does anyone remember why we started doing this in the first place?  I'm 
> sure there are some tools that expect a process tree, rather than a 
> forest, and making it a forest could make them unhappy.
> 
> The support angel on my shoulder says we should just put all the kernel 
> threads under a kthread subtree to shorten init's child list and 
> minimize impact.  The hacker devil on my other shoulder says that with 
> usermode helpers, containers, etc. it's about time we treat it as a 
> tree, and any tools that have a problem with that need to be fixed.
> 
> -- Chris

Err, that should have been "about time we treat it as a forest".

-- Chris
