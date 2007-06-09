Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbXFIHOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbXFIHOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbXFIHO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:14:27 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:34854
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbXFIHOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:14:25 -0400
Date: Sat, 9 Jun 2007 00:13:22 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Sean <seanlkml@sympatico.ca>
cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070609014644.9ed4fa29.seanlkml@sympatico.ca>
Message-ID: <Pine.LNX.4.64.0706090004290.6675@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
 <20070609014644.9ed4fa29.seanlkml@sympatico.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Sean wrote:

> On Fri, 8 Jun 2007 22:18:40 -0700 (PDT)
> david@lang.hm wrote:
>
>> the way I would describe the difference betwen AA and SELinux is:
>>
>> SELinux is like a default allow IPS system, you have to describe
>> EVERYTHING to the system so that it knows what to allow and what to stop.
>>
>> AA is like a default deny firewall, you describe what you want to happen,
>> and it blocks everything else without you even having to realize that it's
>> there.
>>
>> now I know that this isn't a perfect analyogy, that SELinux doesn't allow
>> something to happen unless it's been told to let it, but in terms of
>> complexity and the amount of work to configure things I think the analogy
>> is close.
>
> It must be drop dead simple to modify SELinux to be default-deny.  That
> seems like it could be done in a small patch instead of requiring a huge
> new infrastructure.

did you read my explination of the analogy?

> Let's assume that everyone agrees that AA is a good idea.  Which parts of it
> absolutely can't be implemented in terms of SELinux?  SELinux isn't fixed in
> stone, it can be altered if necessary to accommodate AA (as in the example
> above of becoming default-deny).

what SELinux cannot do is figure out what label to assign a new file.

but the bigger problem in changing SELinux to behave like AA is that the 
SELinux people disagree with the concept of AA. they don't believe that 
it's secure, so why would they add useless bloat that would only 
complicate their code and make systems less secure? I don't happen to 
agree with their opinion of AA obviously, but they have the right to their 
opinion, and it is their code. why should they be asked to implement and 
support something they disagree with so fundamentally?

remember that the security hooks in the kernel are not SELinux API's, they 
are the Loadable Security Model API. What the AA people are asking for is 
for the LSM API to be modified enough to let their code run (after that 
(and working in parallel) they will work on getting the rest of their code 
approved for the kernel, but the LSM hooks are the most critical)

David Lang
