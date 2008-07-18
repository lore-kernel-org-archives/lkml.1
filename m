Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYGRGjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYGRGjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 02:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYGRGjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 02:39:16 -0400
Received: from mail.lang.hm ([64.81.33.126]:53231 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbYGRGjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 02:39:15 -0400
Date: Thu, 17 Jul 2008 23:39:57 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Andi Kleen <andi@firstfloor.org>
cc: Ray Lee <ray-lk@madrabbit.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, torvalds@linuxfoundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <487FABBA.5060009@firstfloor.org>
Message-ID: <alpine.DEB.1.10.0807172318400.6370@asgard>
References: <20080716214516.GA10777@basil.nowhere.org>  <200807170011.12184.rjw@sisk.pl>  <200807161633.01375.jbarnes@virtuousgeek.org>  <487EEAEB.4050009@firstfloor.org>  <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>  <487F71E8.9050705@firstfloor.org>  <2c0942db0807171211s39e2653fwdc50f92d9c3020d2@mail.gmail.com>  <487FA24B.9060803@firstfloor.org> <2c0942db0807171311hae9b3e7v811e024990b05fe4@mail.gmail.com>
 <487FABBA.5060009@firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Andi Kleen wrote:

> Ray Lee wrote:
>> On Thu, Jul 17, 2008 at 12:49 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> Why would you care about the merge and not about the individual patches?
>>> Note that these quilt merges don't have conflicts.
>>
>> Because sometimes merges are non-trivial. If you roll that merge
>> conflict resolution back into the original patch, then the patch is
>> now different. And in all these rebasings, who's to say there won't be
>> a typo that accidentally changes the original patch that has had more
>> testing? We'er all human, y'know?
>
> You only focus only on the merges, but I focus on all the other changes too.
> The reason I maintain patches in quilt is that it's quite easy to
> fix them up.
>
> Besides as a subsystem maintainer the actual conflict points are
> very rare because normally people don't change drivers/acpi without
> going through me.
>
>>>> It's the difference between having tested patches and an untested
>>>> merge, or untested new patches
>>> The patches are as tested individually as they were before. I don't see
>>> how you can call something that was in linux-next for some time and also
>>> in my test tree "untested".
>>
>> Surely you agree that more testing is better? A rebased patch has had
>> less testing than the original patch, by definition.
>
> What I don't agree on is that a rebased patch had less testing than
> a patch that got merged by someone else (in this case Linus) into
> their tree when my tree wasn't at exactly the same point. In both
> cases it's a merge and yes it is untested initially, but not less
> so in both of the cases.
>

Andi,

say you create patch P1 against tree version T1 creating tree T2

you then rebase patch P1 against tree version T5 creating tree T6

people tested tree T2, they didn't test tree T6. while the changes made by 
patch P1 are still the same, there may be other changes that interact with 
things (and not nessasarily by chnaging the same area of the code, they 
may change memory layouts, timing, etc)

when someone is trying to track things down they can no longer recreate 
the state of tree T2, you've wiped the record of that from history. all 
they can do is to test version T5 and T6.

the other approach is that you create patch P1 against tree version T1 
creating tree T2, this then gets merged with tree version T5 upstream 
creating tree T6.

now when someone goes to track down a problem they can see all four tree 
versions, T1, T2, T5, and T6. they can not only test that T5 works but T6 
doesn't, but they can test that T2 works as well. They then can immediatly 
start looking for other interactions that are the result of the merge (and 
what's different between T1 and T5) rather then focusing just on 'what did 
patch P1 change'


now, it's also not good to have large areas of non-bisectable trees and 
bugs with their fixes a lot later, but with distributed testing and 
development you will never completely eliminate this.

there are things that you can do to minimize that, and using some number 
of topic branches seems to be one of the big ones (and I'll point you at 
the other explinations from this thread that have focused on what those 
are)

David Lang
