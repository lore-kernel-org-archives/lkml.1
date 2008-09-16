Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYIPQs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYIPQs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYIPQsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:48:18 -0400
Received: from mout.perfora.net ([74.208.4.194]:58149 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbYIPQsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:48:17 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2008 12:48:17 EDT
Message-ID: <48CFE1FF.50505@rajgad.com>
Date: Tue, 16 Sep 2008 09:42:39 -0700
From: "Amit D. Chaudhary" <amitch@rajgad.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: ext3 mount infinite loop over orphan list issue, please	release
 2.6.27
References: <48CEDD12.4060901@rajgad.com> <20080916125345.GA13388@mit.edu>
In-Reply-To: <20080916125345.GA13388@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/KzHkcEmLZXyxg0BlRsmI6zUfNtdqQIoimopW
 ua0hIVKb14T9I3zEboRI1IS/1By2Klt0KaDQOarVlG6fBpoznc
 1anFaMxmVQVUVks6oGt4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ted,

Thanks for noting that the problem does happen in the real world, though 
rarely or users do not narrow it down. Yes, it makes sense for all 
regressions to be fixed before releasing 2.6.27.

I have put your suggestion about the Rescue CD & patch to kernel to the 
Ubuntu forums & bug. The latter would solve it only for one 
distribution, it is a start. Good point about the Rescue CD, I will get 
one from other distributions next time, if needed. There is no way of 
skipping mount\scan of filesysytems on the disk for the Ubuntu live CD 
that I found.

I am aware of the Open Source implications & off the fact that 
unrecoverable crashes happen to all OSes\Kernel sometime or other.

Regards
Amit

PS: Resent as text

Theodore Tso wrote:
> On Mon, Sep 15, 2008 at 03:09:22PM -0700, Amit Chaudhary wrote:
>   
>> Over the weekend, due to a crash, I ran into the ext3 mount infinite  
>> loop over orphan list issue. This was on Ubuntu 8.04. I tried many  
>> things, including using 18 month old distributions, nothing works. Only  
>> solution is to boot off a alpha version of next Ubunuty which has the  
>> 2.6.27 kernel (rc1 has the fix), more details are below:
>>
>> Can you please release 2.6.27 so that it can make it to stable  
>> distributions.
>>     
>
> As you point out, this problem has been fixed in 2.6.27-rc1.
> Unfortunately, it is a problem which has been around for a very long
> time --- perhaps since ext3 was first written.  No one had noticed the
> problem for a very long time; in fact the first time someone reported
> it as far I know was June 6, 2008, when Sami Liedes found it via a
> synthetic testing program, fsfuzzer, which creates filesystems, then
> corrupts them randomly and then sees whether or not they cause the
> kernel to panic or hang when they are mounted.
>
> You seem to have had the bad luck of running into the problem in a
> real world situation relatively recently, but this has been a
> long-standing problem.
>
> As far as releasing 2.6.27, there still is a fairly large set of
> regressions (i.e., bugs introduced in 2.6.27-rc1 or later) which need
> to be fixed before we can release it; otherwise more users will have
> bad experiences when older kernels that had worked fine for them will
> break for them.  So while it might have helped you to have released
> 2.6.27, it could make things worse for many other users.  So that's
> not a realistic option.  If I had to guess, given currently the
> projected regression bug fix rates, there still is at least 2 or so of
> bug fixing that still needs to be done before 2.6.27 is ready for
> release.
>
> We could take this bug fix and nominate it for release in the next
> 2.6.26-stable series, which distributions could then pick up --- maybe
> we should have, but when the patch went in, it was seen was a fix for
> largely theoretical problems, and not something that needed
> accelerated handling.  This is still something we could do, but
> realistically I'm not sure it's going to help the Ubuntu Intrepid
> release, since it's pretty late in their schedule.  You might be
> better off asking the Ubuntu kernel team if they are willing to cherry
> pick the commit in question (ae76dd9a) and include it in their
> release; they do have the ability to do that without waiting for an
> upstream release, you know.
>
> You also should have been able to work around the problem if you had
> booted a rescue CD and checked your filesystem from the rescue CD.
> That is the normal way these sorts of problems are fixed, and I'm a
> bit surprised you didn't try this first.  It could be that Ubuntu
> Rescue CD's could be made better by automating the ability of (upon
> request) detecting the root filesystem on Ubuntu systems and then
> running e2fsck on the filesystem before trying to mount them.
>
> If you are willing to help out, we can always use more testers to test
> the development kernels.  We can't do this alone, you know.  We've
> wanted to shorten the release window, but in order to do that we need
> more people helping to find and fix bugs during the development cycle.
> Remember, this is open source.  If you see a problem you don't like,
> you can help fix it.  And in fact, that's the most likely way that it
> will get fixed.
>
> Best regards,
>
> 						- Ted
>   
