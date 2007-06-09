Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbXFIFUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbXFIFUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 01:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXFIFUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 01:20:00 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:32983
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbXFIFT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 01:19:59 -0400
Date: Fri, 8 Jun 2007 22:18:40 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Greg KH <greg@kroah.com>
cc: Andreas Gruenbacher <agruen@suse.de>, Stephen Smalley <sds@tycho.nsa.gov>,
       Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070609001703.GA17644@kroah.com>
Message-ID: <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Greg KH wrote:

> I still want to see a definition of the AA "model" that we can then use
> to try to implement using whatever solution works best.  As that seems
> to be missing the current argument of if AA can or can not be
> implemented using SELinux or something totally different should be
> stopped.

the way I would describe the difference betwen AA and SELinux is:

SELinux is like a default allow IPS system, you have to describe 
EVERYTHING to the system so that it knows what to allow and what to stop.

AA is like a default deny firewall, you describe what you want to happen, 
and it blocks everything else without you even having to realize that it's 
there.

now I know that this isn't a perfect analyogy, that SELinux doesn't allow 
something to happen unless it's been told to let it, but in terms of 
complexity and the amount of work to configure things I think the analogy 
is close.


the fact that the SELinux policy _will_ affect the entire systems means 
one of two things.

1. you have a policy that exactly describes how every part of the system 
operates

or

2. you have a policy that's exessivly permissive in some parts of the 
system becouse 'that works' and you either don't understand that part of 
the system well enough, or don't have time to write a more complete 
policy.

I would argue that with the number of files on a system nowdays (483,000 
on my 'minimalistic' gentoo server, 442,000 on my slackware laptop, 
800,000 on a ubuntu server at work) it's not possible to do #1, so any 
deployed policy (especially one done by a disto that needs to work for all 
it's users) is going to follow #2, frequently to the point where it's not 
really adding much security.

David Lang

