Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbXGBQuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbXGBQuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 12:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbXGBQt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 12:49:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53517 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbXGBQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 12:49:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
References: <20070626230756.519733902@suse.de>
	<20070626165202.bfe8e6df.akpm@linux-foundation.org>
	<20070627022403.GB14656@suse.de>
	<20070626194700.5b0ff477.akpm@linux-foundation.org>
	<20070627151114.GM1094@stusta.de>
Date: Mon, 02 Jul 2007 10:45:09 -0600
In-Reply-To: <20070627151114.GM1094@stusta.de> (Adrian Bunk's message of "Wed,
	27 Jun 2007 17:11:14 +0200")
Message-ID: <m1sl86iwkq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

> On Tue, Jun 26, 2007 at 07:47:00PM -0700, Andrew Morton wrote:
>> On Tue, 26 Jun 2007 19:24:03 -0700 John Johansen <jjohansen@suse.de> wrote:
>> 
>> > > 
>> > > so...  where do we stand with this?  Fundamental, irreconcilable
>> > > differences over the use of pathname-based security?
>> > > 
>> > There certainly seems to be some differences of opinion over the use
>> > of pathname-based-security.
>> 
>> I was refreshed to have not been cc'ed on a lkml thread for once.  I guess
>> it couldn't last.
>> 
>> Do you agree with the "irreconcilable" part?  I think I do.
>> 
>> I suspect that we're at the stage of having to decide between
>> 
>> a) set aside the technical issues and grudgingly merge this stuff as a
>>    service to Suse and to their users (both of which entities are very
>>    important to us) and leave it all as an object lesson in
>>    how-not-to-develop-kernel-features.
>> 
>>    Minimisation of the impact on the rest of the kernel is of course
>>    very important here.
>> 
>> versus
>> 
>> b) leave it out and require that Suse wear the permanent cost and
>>    quality impact of maintaining it out-of-tree.  It will still be an
>>    object lesson in how-not-to-develop-kernel-features.
>>...
>
> versus
>
> c) if [1] AppArmor is considered to be something that wouldn't 
>    be merged if it wasn't already widely deployed by Suse: leave it out, 
>    work on an ideal solution [2], and let Suse wear the one-time cost
>    of migrating their users to the ideal solution
>
> One important point is that if AppArmor gets merged there will be much 
> more distribution support for it, and many people on !Suse will start 
> using it.
>
> I'm not claiming to understand the technical details, but from both 
> slightly reading over the previous discussions and the "What are the 
> advantages of AppArmor over SELinux?" section in the AppArmor FAQ [3] my 
> impression is that a main advantage of AppArmor are more user friendly 
> userspace tools. Therefore, if [1] AppArmor is considered technically 
> inferior to SELinux, it might still become more popular than SELinux 
> simply because it's easier to use - and although it's technically 
> inferior.


A couple of random thoughts to mix up this discussion.

>From what I have been able to observer the LSM is roughly firewalls
rules for in box operations.  All it can do is increase the chances
you will get -EPERM.

Not being able to take path names into consideration is a current
deficiency of the LSM.

Being exported to modules is another deficiency of the current LSM
as it seems no serious user of the LSM can exist simply as a kernel
module.

Not being able to mix code from different projects is also a very
serious limitation of the LSM.  Currently I don't think we can
build a kernel that supports selinux and any other LSM at the same
time.  Which horribly limits what we can do with the LSM.

So it seems clear that if we are aiming at an ideal solution.  We
first need to enhance the LSM.  Then merge in the AppArmor
functionality.  Doing it all in one patch series looks to overwhelming
for a decent code review.

That said is anyone interested in making the LSM more like iptables
with a generic table based rules structure?  That way we could fix
the one true LSM problem and concentrate on simpler pieces that give
specific bits of interesting functionality.  Or at the very least
be able to compile in multiple different bits of functionality into
the kernel simultaneously.

I'm really not familiar with the security issues the LSM addresses
but I do know, it encourages huge incompatible mega solutions, and
it tends to break when I fix real security problems in the kernel.
So at this point I am convinced that the LSM is deficient, has very
limited usability, and seems to be a very fragile firewall structure
to me.

Eric
