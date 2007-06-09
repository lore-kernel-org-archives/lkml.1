Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbXFIFkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbXFIFkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 01:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXFIFkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 01:40:00 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:47256
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbXFIFj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 01:39:59 -0400
Date: Fri, 8 Jun 2007 22:38:57 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Sean <seanlkml@sympatico.ca>
cc: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,pathname
 matching
In-Reply-To: <20070609011022.ac332fc7.seanlkml@sympatico.ca>
Message-ID: <Pine.LNX.4.64.0706082224370.6675@asgard.lang.hm>
References: <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
 <200706091101.JAB31303.PTNNSGtM@I-love.SAKURA.ne.jp>
 <20070608232531.d68de09f.seanlkml@sympatico.ca> <Pine.LNX.4.64.0706082138360.6675@asgard.lang.hm>
 <20070609011022.ac332fc7.seanlkml@sympatico.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Sean wrote:

>>
>> the AA policy is also much easier to understand becouse you can look at it
>> in pieces, understand that piece, and then forget it and move on to the
>> next piece.
>
> Nobody is asking you to change the AA policy file.  It lives in user space.
> But i fail to see the problem in translating it into SELinux terms for
> the user transparently.



>> for example, if you write a policy for apache that limits it's access to
>> it's log files, install directories, and document root. then you write a
>> policy for your log analysis tool to access it's libraries, report
>> directories (under the apache document root) and the apache log files
>> (read only), these two policies are independant, you don't have to think
>> about one while creating the other (which you would have to do if you had
>> to put one label on apache binaries, another on normal web documents, a
>> third on the reports, a fourth on the log files, and a fifth on the
>> binaries for the log analysis tool. and this is ignoring any overlap in
>> libraries!)
>
> Again, try to think outside the box a bit.  This isn't about using SELinux
> as it exists today.  But imagine an SELinux that would ask you to
> supply a security label for each file _instead_ of looking up that label
> itself.  Wouldn't that let you implement everything you wanted while still
> using much of the SELinux infrastructure that is already in the kernel?

so are you suggesting that SELinux would call out to userspace for every 
file open to get the label for that file?

just off the top of my head

what would all these kernel->userspace->kernel transitions do to 
performance?

would SELinux give userspace the full path to that file?

if so wouldn't it have to implement most of what AA adds to do this?

if not how would userspace figure out what label to hand back without this 
info?

how would SELinux figure out the permissions for the userspace Daemon?

how would you change both the rules for labels in the kernel and the 
policy for assigning labels in userspace without any race conditions?

>> AA also lets a sysadmin dip their toe in the water and just write a policy
>> for Apache, not for anything else, then write a policy for firefox, then
>> write a policy for their mail client, then for bittorrent, etc. there is
>> no need or push to try and secure everything all at once, and no need to
>> re-label files (and change any policies that used the old labels) when
>> you discover a new interaction.
>
> And so it could remain;  this is about implementation, not model.

yes, you could add all the AA code to SELinux and then say that the result 
is implemented in SELinux, you may even save a little bit of code in some 
parts of it (but I would argue that you add more code in others, say for 
the userpace interface and userspace labeling code), but the result 
wouldn't be in the spirit of SELinux.

it may be possible to write something that resembles AA in SELinux policy 
(once you solve the problem of how to label newly created files securely), 
but it's also possible to write a webserver in COBOL to run out of inetd, 
that doesn't mean that it makes any sort of sense to do either one.

on the other hand, it may be a good idea. let's see how people really use 
AA once they have it available and the SELinux folks can work on 
duplicating the functionality, if they do then the existing AA interface 
could be phased out over time, or the internal implementation could 
change. but arguing that SELinux _may_ be able to do the job of AA 
_someday_ should not prevent AA from being included today (especially when 
so many of the SELinux developers are so opposed to the very concept of 
AA, which doesn't indicate that they are about to rush out and implement 
the pieces needed to make it work)

David Lang


