Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbXJaFAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbXJaFAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbXJaFAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:00:37 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:52430
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbXJaFAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:00:35 -0400
Date: Tue, 30 Oct 2007 22:08:11 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Peter Dolding <oiaohm@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <e7d8f83e0710301921m3460f8dfkce72c4fc549ded4a@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710302145480.4780@asgard.lang.hm>
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl> 
 <4726377A.4080807@crispincowan.com>  <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>
  <Pine.LNX.4.64.0710301136560.31325@fbirervta.pbzchgretzou.qr> 
 <4727C06A.4060005@gmail.com>  <Pine.LNX.4.64.0710301713260.8703@asgard.lang.hm>
 <e7d8f83e0710301921m3460f8dfkce72c4fc549ded4a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Peter Dolding wrote:

> On 10/31/07, david@lang.hm <david@lang.hm> wrote:
>> On Wed, 31 Oct 2007, Peter Dolding wrote:
>>
>>> MultiAdmin loaded before Selinux breaks Selinux since Multi Admin rules are
>>> applied over using Selinux rules.  This is just the way it is stacking LSM's
>>> is Just not healthy you always risk on LSM breaking another.  Part of the
>>> reason why I have suggested a complete redesign of LSM.  To get away from
>>> this problem of stacking.
>>
>> since the method of stacking hasn't been determined yet, you can't say
>> this.
>
> I can because that is the current day problem. With many LSM's loaded
> they stack completely as a complete mess and with problems.  They
> fight with each other.  Lack of define on stacking equals big
> problems.   Since you have not created a standard for stacking does
> not stop the problem from existing.  Nice lack of planing when LSM
> started or maybe its intentional.  When you need stacking its about
> time you start moving things into the OS?

the lack of a stacking ability was deliberate (go back and read the 
archives). basicly no LSM was willing to admit that they weren't the 
be-all, end-all of security, so nobody was willing to consider that anyone 
would ever want anything else.

one method of doing the stacking would be for the LSM to not know about 
the stacking, but the kernel takes care of passing all requests through 
each LSM in order (if the LSMs can be staticly compiled the order should 
be able to be changed at compile time)

now, the existing policies for some LSM's may need to change, becouse 
they've been assuming that they only needed to check capabilities for 
UID=0, when they will now need to check them for everyone, but arguably, 
this was a bug masquerading as an optimization in the first place.

> There is a way around the problem too without allowing LSM to stack.
> Good advantage backward compatible  because your are not playing with
> the LSM standard to do it so no LSM modules should need large
> alterations.  At worse mirror extensions to handle the new OS feature.
> Posix File Capabilities provide the solution.   First done as a LSM
> risked conflict.   Moved in as a operating system extension by by
> conflict.  Fragments from LSM's should exactly move that way if they
> expect to be overlapped by other models.
>
> Lot of stacking problems can be avoided if segments are complete
> standard extensions.

which LSM gets to declare the standards?

>>
>> it would be possible for MultiAdmin to grant additional access, that
>> SELinux then denies for it's own reasons.
>>
>> if the SELinux policy is written so that it ignores capabilities, and
>> instead just looks at uid0 then that policy is broken in a stacked
>> environment, but it's the polciy that's broken, not the stacking.
>
> That is not how current day always works.  MultiAdmin grants and that
> can be the end of the treeing.   Selinux does not get asked if it
> refuses it or not.  So no matter what was set in the Selinux policy it
> may never get used.   Adding more layers is also bad for performance
> to.  Treeing threw modules for rights is a really slow process.  As
> like a posix feature extension.   Selinux/Other LSM's is at top of
> allocation no flaw no bypass.

only if the stacking mode permits this. if it always requires passing 
through all the layers then this wouldn't be a problem.

Besides which, the MultiAdmin authors would probably be willing to make 
the nessasary changes to their LSM to play nicely with others anyway (but 
good programming practice would dictate that you don't count on it, and 
arrange for the other modules to approve as well)

>> yes, there will be interactions that don't make sense, but just becouse
>> something can be used wrong doesn't mean that there aren't other cases
>> where it can be used properly.
>>
> We are talking security here if its not order safe its not good.
> MultiAdmin done as a posix feature extension is order safe.
> MultiAdmin done as a LSM is not order safe.

as things are currently written, it's not possible to stack, so there is 
no order. change how things are written and you can make them safe.

> System Admins are humans too.  Getting orders backwards does happen.
> So should be avoided where able.

the sysadmins need to be given enough rope, you don't know everything that 
they are trying to do, and you don't know what other LSMs going to do. so 
how can you possibly decide ahead of time what orders are safe?

> This completely avoids the need for adding another layer of stacking
> and since built inside current day framework.  Does doing this risk
> the end of LSM's as we know it yes it does.  Since it is not being
> used as LSM were intended.  LSM is just a addon to standard OS
> security what is either a testing ground for new features to secure
> the OS that get build into the OS in time or as location for security
> modules.
>
> Somethings should be just done in the Standard OS security nothing to
> do with LSM.
>
> Little bit hard for some I guess to hear that LSM are not all
> important and not all Security features should be done in them.  Some
> should be done in the main OS security features.
>
> Biggest current day problem with LSM is they have forgot that LSM is
> only a testing ground or a zone for features that people will only
> want some of the time.

no, LSM is not just for testing, LSM is an interface so that Linus doesn't 
need to pick the 'one true security model' and enforce it on everyone.

it's like freedom of religion, each religion belives that they are the one 
true path, but in exchange for the guarentee that they are not going to be 
percecuted, they reluctantly allow all other religions equal freedom. when 
religion passes from mearly strange to activly harmful (i.e. cults) you 
find the edge of the freedom.

similarly, LSMs need to accept the fact that some people don't want their 
flavor of security, so to avoid being thrown out entirely they need to 
allow other LSMs to exist, and use the same kernel hooks, even if they 
believe that the alturnatives are misguided. as long as an LSM is not 
activly harmful (as opposed to mearly being snake oil) it should be 
allowed.

> MultiAdmin is a feature that can enhance means to Audit OS ie who did
> what.  Enhance security hand outs and can be really handy with almost
> any LSM on the system.  Its description of what it is sounds very much
> like every other standard feature.
>
> Lets end the bitrot.  Start having bits go into the main OS security
> features where they should be.

which bits into which security features? Good, knowledgable people can't 
agree on what's right.

ending the bitrot just requires accepting the LSMs into the kernel as 
first-class options, it doesn't require declaring any one LSM (or even any 
part of any one LSM) as being the 'one right way' to do something and 
force everyone to use that way.

David Lang
