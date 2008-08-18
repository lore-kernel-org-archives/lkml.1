Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbYHRMfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbYHRMfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYHRMev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:34:51 -0400
Received: from mail.lang.hm ([64.81.33.126]:33013 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYHRMet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:34:49 -0400
Date: Mon, 18 Aug 2008 05:34:29 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: tvrtko.ursulin@sophos.com
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       capibara@xs4all.nl, Casey Schaufler <casey@schaufler-ca.com>,
       davecb@sun.com, Eric Paris <eparis@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Rik van Riel <riel@redhat.com>,
       rmeijer@xs4all.nl, Theodore Tso <tytso@mit.edu>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to
 a linux interface for on access scanning (fwd)
In-Reply-To: <20080818122003.4ACC02FE864@pmx1.sophos.com>
Message-ID: <alpine.DEB.1.10.0808180524110.12859@asgard.lang.hm>
References: <20080818122003.4ACC02FE864@pmx1.sophos.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, tvrtko.ursulin@sophos.com wrote:

> david@lang.hm wrote on 18/08/2008 12:44:12:
>
>> On Mon, 18 Aug 2008, tvrtko.ursulin@sophos.com wrote:
>>
>>> David Lang wrote on 18/08/2008 02:25:44:
>>>
>>>> what is not covered by this design that is covered by the threat
> model
>>> being
>>>> proposed?
>>>>
>>>> what did I over complicate in this design? or is it the minimum
> feature
>>> set
>>>> needed?
>>>>
>>>> are any of the features I list impossible to implement?
>>>
>>> One more thing - this proposal does not work where there are no
> extended
>>> attributes (whether at all or they are disabled at mount time). I
> think
>>> that is a serious flaw or at least disadvantage compared to the posted
>>> implementation.
>>
>> good point. I should have listed that.
>>
>> I don't see it as a serious flaw, people who care about this feature can
>
>> just pick an appropriate filesystem to use.
>
> You mostly cannot pick not use vfat, isofs and udf.

two options come to mind

1. unionfs with a ramdisk

2. add xattr simulation code to the filesystem

but in any case, most of your system is not going to be on those 
filesystems. I'm far more worried about optimizing away the need to scan 
the bash binary every time it's invoked by the system then I am having to 
scan files on a CD each time they are opened.

>> but if extended attributes are not found a strict implementation could
>> fall back to scanning on every file access (the extended attributes are
>> being used to cache the results of the scans)
>
> Performance impact may or may not be acceptable

well, some people are arguing that the scans are fast enough that nothing 
other then on-access scanning should be done. you can't both be right ;-)

> but I dislike the concept of core security interface which is not really 
> core.

people differ significantly on how 'core' this is. this goes back to the 
threat model and how much you are trying to defend against. if you are 
trying to defend against root or already running malware, then you are 
absolutly right, this is nowhere close to being bulletproof agaist those 
types of threats, but neither were the other proposals listed. with the 
threat model that was outlined those threats are being dealt with 
seperatly (by people useing SELinux or other LSM)

I'm seeing this as more a solid file scanner support interface of which 
security is just one of the users.

David Lang

P.S. thanks for looking over the proposal, it's nice to actually deal with 
issues with it instead of with what people think it may have been :-)
