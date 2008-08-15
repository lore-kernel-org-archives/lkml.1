Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYHOBh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYHOBh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 21:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYHOBhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 21:37:20 -0400
Received: from mail.lang.hm ([64.81.33.126]:56107 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbYHOBhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 21:37:19 -0400
Date: Thu, 14 Aug 2008 18:37:31 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: tvrtko.ursulin@sophos.com
cc: Eric Paris <eparis@redhat.com>, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net,
       peterz@infradead.org, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
In-Reply-To: <20080814094701.A65372FE89E@pmx1.sophos.com>
Message-ID: <alpine.DEB.1.10.0808141835020.13400@asgard.lang.hm>
References: <20080814094701.A65372FE89E@pmx1.sophos.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, tvrtko.ursulin@sophos.com wrote:

> Eric Paris wrote on 13/08/2008 19:57:44:
>
>>> It's clear from the protection model that you described that on 'read'
>>> you want to wait until the scan is done before you give the data to
> the
>>> process asking for it... and that's totally reasonable: "Do not give
>>> out bad data" is a very clear line in terms of security.
>>>
>>> for the "dirty" case it gets muddy. You clearly want to scan "some
>>> time" after the write, from the principle of getting rid of malware
>>> that's on the disk, but it's unclear if this HAS to be synchronous.
>>> (obviously, synchronous behavior hurts performance bigtime so lets do
>>> as little as we can of that without hurting the protection).
>>> One advantage of doing the dirty case async (and a little time
> delayed)
>>> is that repeated writes will get lumped up into one scan in practice,
>>> saving a ton of performance.
>>> (scan-on-close is just another way of implementing "delay the dirty
>>> scan").
>>> Based on Alans comments, to me this sounds like we should have an
>>> efficient mechanism to notify userspace of "dirty events"; this is not
>>> virus scan specific in any way or form. And this mechanism likely will
>>> need to allow multiple subscribers.
>>
>> I'm certainly willing to go down the inotify'ish path for async
>> notification of 'dirty' inodes instead of implement my own async
>> mechanism if I can find a way to do it.
>
> Do I understand correctly that everyone agrees scanning whenever an inode
> gets dirty would be a terrible thing for performance?
>
> Another thing we have here is that malware could not be neccessariliy
> identified until the very last write (one example where it will always be
> the case are PDF files (I think)).
>
> So the whole question is at which point should be performing an async
> scan. Close seems like a natural point which should be ideal for majority
> of applications, I don't see how any time-based lumping/delaying scheme
> can be better than close?

all you need is the ability to mark a file as 'dirty', and some way for 
programs that are interested in dirty files learning about it later and 
decideing to do a scan. if the file gets dirtied again after they do they 
scan they will need to do another one (this is a classic trade-off between 
the 'security' of looking for things quickly or 'efficiancy' of only 
looking when you don't think they will change again. in other words, 
policy -> userspace)

David Lang
