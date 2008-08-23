Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYHWH3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYHWH3K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 03:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYHWH25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 03:28:57 -0400
Received: from mail.lang.hm ([64.81.33.126]:46774 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbYHWH24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 03:28:56 -0400
Date: Sat, 23 Aug 2008 00:28:18 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@suse.cz>
cc: Eric Paris <eparis@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
       Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro
 linux interface for  for access scanning
In-Reply-To: <20080822150917.GA8152@ucw.cz>
Message-ID: <alpine.DEB.1.10.0808230009530.25127@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com> <1219076143.15566.39.camel@localhost.localdomain> <20080818171500.78590801@lxorguk.ukuu.org.uk> <1219080504.15566.65.camel@localhost.localdomain> <20080818182556.13ced58f@lxorguk.ukuu.org.uk>
 <1219082097.15566.82.camel@localhost.localdomain> <20080818183540.GA5470@cs.cmu.edu> <1219085176.15566.100.camel@localhost.localdomain> <alpine.DEB.1.10.0808181159400.15109@asgard.lang.hm> <alpine.DEB.1.10.0808191906270.20991@asgard.lang.hm>
 <20080822150917.GA8152@ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008, Pavel Machek wrote:

> To: david@lang.hm
>
>> Eric is viewing this through the AV point of view,
>>   this means
> ...
>> He is thinking that any ability to avoid doing the scan
>> is a security hole.
>
> That's contrary to the threat model ('it is just a scanner').
>
> (Plus you can't do it. mmap. Of course you can pass viruses between
> two cooperating applications... and you can do it through filesystem,
> too. And you probably can make un-cooperating network server serve
> viruses, as long as the network server uses mmap.)

by the way, sendfile and splice will probably also cause grief (or at 
least open-only checks like mmap)

> This is the thing that makes antivirus ugly, its unique to the
> antivirus, plus it can't be done. I.e. bad goal.

the items that I see as the potentially difficult policy decisions

1. when to scan files on access

and the more dificult issue,
2.when to allow access to unscanned files

3. what to do if different scanners disagree with each other


I think Eric's answers would be

1. unless they are already marked as being scanned since rebooting

2. only when a scanner program is doing the access, unless the scanner 
programs all decide differently.

3. only allow access if all scanners agree.


My answers are

1. unless they have already been marked by the current generation of 
scanner signatures

2. depends wildly on the environment. some uses will want to follow Eric's 
very strict policy, others will only want to impose the on-access scanning 
on software expected to be exposed to windows clients, yet others will 
want to scan by default, but exempt programs that don't interpret their 
input (for example 'wc')

I also don't know how the kernel could reliably figure out what program is 
asking for access. I guess you could try to do something with SELinux 
tags, but that makes this system dependant on SELinux, plus since you can 
only have one tag on the program it will potentially double the number if 
unique tags on the system, with a significant complication to the ruleset 
to make each of the tags identical, except for this one function.

3. like #2 depends wildly on the environment and what scanners are in use. 
I could easily see a 'majority vote wins' with three (or more) AV scanners 
in use. I could also see having a checksum based scanner override the 
decision of a heristic based scanner

David Lang
