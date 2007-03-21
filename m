Return-Path: <linux-kernel-owner+w=401wt.eu-S964838AbXCUUWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838AbXCUUWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964871AbXCUUWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:22:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33389 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838AbXCUUWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:22:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Adrian Bunk <bunk@stusta.de>
Cc: Sid Boyce <g3vbv@blueyonder.co.uk>, linux-kernel@vger.kernel.org,
       auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45E59D64.3070202@blueyonder.co.uk>
	<200702281805.13822.auxsvr@gmail.com>
	<20070307214730.87859590.akpm@linux-foundation.org>
	<45EFBC73.2030005@blueyonder.co.uk>
	<46016EAF.6010801@blueyonder.co.uk> <20070321193420.GP752@stusta.de>
Date: Wed, 21 Mar 2007 14:17:40 -0600
In-Reply-To: <20070321193420.GP752@stusta.de> (Adrian Bunk's message of "Wed,
	21 Mar 2007 20:34:20 +0100")
Message-ID: <m17itabbbv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

> On Wed, Mar 21, 2007 at 05:43:11PM +0000, Sid Boyce wrote:
>> Sid Boyce wrote:
>> >Andrew Morton wrote:
>> >>(cc restored.  Please always do reply-to-all)
>> >>
>> >> 
>> >>>On Wed, 28 Feb 2007 18:05:13 +0200 auxsvr@gmail.com wrote:
>> >>>On Wednesday 28 February 2007 17:19, Sid Boyce wrote:
>> >>>   
>> >>>>openSUSE 10.3 Alpha and KDE-3.5.6, xorg-x11-7.2. KDE is setup not to
>> >>>>require a password to unlock, but it asks for password. When the screen
>> >>>>unlocks, kwin is gone with no errors logged in /var/log/kdm or
>> >>>>/var/log/messages. No problems with 2.6.20.
>> >>>>
>> >>>>Same problem on openSUSE 10.2 x86_64, KDE-3.5.5 and 2.6.21-rc2.
>> >>>>Regards
>> >>>>Sid.
>> >>>>      
>> >>>This is the linux kernel mailing list. Perhaps you should post your 
>> >>>problem to the opensuse mailing list.
>> >>>    
>> >>
>> >>2.6.20 worked.
>> >>
>> >>2.6.20-rc2 did not.
>> >>
>> >>Working theory: the kernel broke.
>> >>
>> >>Sid, the chances that anyone can work out what caused this are pretty 
>> >>low. It would be great if you could perform a git bisection search 
>> >>sometime in
>> >>the next few weeks, work out which commit caused this.
>> >>
>> >>Thanks.
>> >>
>> >>
>> >>
>> >>  
>> >I shall go back to 2.6.20-git3 and work forward. Up to 2.6.20-git2 was OK.
>> >Regards
>> >Sid.
>> >
>> 
>> I tracked the problem down to 2.6.20-git11. Up to 2.6.20-git10 is OK, 
>> but from 2.6.20-git11 up to current 2.6.21-rc4-git2 all exhibit the problem.
>
> Thanks for this search.
>
> Looking at the changes between 2.6.20-git10 and 2.6.20-git11, the only 
> suspicious changes are the 60 sysctl patches by Eric.
>
> Eric, can you look at this issue?

git bisect between git10 (ac98695d6c1508b724f246f38ce57fb4e3cec356)
and git11 (86a71dbd3e81e8870d0f0e56b87875f57e58222b) is likely the most
productive thing that can be done right now.  

I can't think of anything in my sysctl patches that would kill an
application.  My sysctl work is right on the border with user space
so it is a good candidate but at the same time there should have
been no user visible changes.  There were a few places where
I removed sys_sysctl support (but not /proc/sys support) but I don't
think any of those were on x86, and they were is such a messed up
state I don't think anyone could have reasonably used them anyway.

So I think either we poke blindly making random guess by hand or
we let git-bisect do it.

Sid do you think you can figure out git-bisect?
git-bisect start
git-bisect bad 86a71dbd3e81e8870d0f0e56b87875f57e58222b
git-bisect good ac98695d6c1508b724f246f38ce57fb4e3cec356

It should narrow the problem down to a single commit in 6-8 tries
after which point we should have enough information to start
making intelligent guesses. 

Eric
