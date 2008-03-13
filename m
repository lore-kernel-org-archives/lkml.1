Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYCMPNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYCMPNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYCMPNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:13:08 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:54925 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYCMPNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GstyAN9J1LXg1uwgBypjRaKX87OlZuM6Y2hcVPkO9ad438+W8uUlBGjp4B685rD351bTcTziV9KtbbzRI77BlRyTNQiZbtgLl8l3biuyj3y9iSagfMGH2lLChTlQX9MxVlkJwXLIfHxKuYY1uyx7sFdBpf/YhXtdU6lYe6U6h2I=
Date: Thu, 13 Mar 2008 12:13:54 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Mike Galbraith <efault@gmx.de>, Jan Knutar <jk-lkml@sci.fi>,
       linux-kernel@vger.kernel.org, Hans-Peter Jansen <hpj@urpla.net>,
       Jiri Kosina <jkosina@suse.cz>, David Newall <davidn@davidnewall.com>,
       Theodore Tso <tytso@mit.edu>, "Fred ." <eldmannen@gmail.com>
Subject: Swap makes X unfair (was Re: Keys get stuck)
Message-ID: <20080313151354.GA5252@localhost.ift.unesp.br>
Mail-Followup-To: Helge Hafting <helge.hafting@aitel.hist.no>,
	Mike Galbraith <efault@gmx.de>, Jan Knutar <jk-lkml@sci.fi>,
	linux-kernel@vger.kernel.org, Hans-Peter Jansen <hpj@urpla.net>,
	Jiri Kosina <jkosina@suse.cz>,
	David Newall <davidn@davidnewall.com>, Theodore Tso <tytso@mit.edu>,
	"Fred ." <eldmannen@gmail.com>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <200803122222.05663.hpj@urpla.net> <1205386933.4797.22.camel@marge.simson.net> <200803131148.22056.jk-lkml@sci.fi> <1205407693.6686.16.camel@marge.simson.net> <20080313120238.GA3860@localhost.ift.unesp.br> <47D937A2.9070305@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D937A2.9070305@aitel.hist.no>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13.Mar'08 at 15:18:10 +0100, Helge Hafting wrote:
> Carlos R. Mafra wrote:
>> On Thu 13.Mar'08 at 12:28:13 +0100, Mike Galbraith wrote:
>>   
>>> [...]
>>> Swap can definitely keep X off the cpu for extended periods,
>>> [...]
>>>     
>>
>> So I would like to ask if swap letting X (and everything else
>> in my experience) out of the cpu for extended periods is
>> considered normal behaviour, in the sense that nobody is
>> trying to "fix" it (due to it being considered impossible
>> to fix)...?
>>   
> Yes, this is perfectly normal. A heavily swapping machine
> will swap out parts of X.

Right, but making the mistake of not being very precise
I would not say my desktop was "heavily swapping". 

> Now, if X has a need for low-latency for keyboard handling,
> then the X developers can use mlock to lock
> the X keyboard service in memory, and make it a real-time
> (or at least high priority) process too.  This should
> avoid the problem even with extreme swapping and/or
> high cpu load.

That would be a great thing for me. But why one wouldn't
want this behaviour to be default for a desktop? I mean
it should be like that already for a desktop experience.

I don't care if xjed takes longer to load the 380MB file 
while swapping something as long as I don't feel my 
desktop has come to an almost frozen state.

>> Sorry for being off-topic, but I run a minimal Window Maker
>> desktop in a P4 3.0 GHz with 512 MB of RAM (around 140 MB
>> being used as per 'free'), and trying to load a 380 MB text
>> file in xjed editor makes my whole desktop quite unfair...
>> it takes tens of seconds to switch desktop, type things in
>> the terminal etc. 
>>   
> Seems ou use too much memory then. 

Well, Window Maker by itself uses around 5-10 MB of RAM.
The 140 MB figure was with firefox and thunderbird openned,
plus a few xterm + mrxvt.

> If xjed
> wastes memory (by bringing the entire file into memory
> in one go) then you'll get some swapping.

I tried with emacs and it simply said something like this:
"Are you sure you want to open this big file?"
I said 'yes' and emacs reffused with "Buffer memory excedded" or
something like that.
At least xjed openned the file :-)

Well, I must say that 'vi' could open the file almost
immediately under the same situation tough.

>> Is there some law in the nature of computers which says
>> that when swapping everything else waits for swap to finish its business? 
>> I hope not :-)
>>   
> No such law, but there are badly implemented software
> around. If xjed is capable of delaying all X events while
> loading the file, for example . . .

Yeah, xjed uses too much memory for this, but it would be
"harmless" if there were some mechanism to prevent swap (not
too heavy) from starving the whole system.

Why can't there be a swap scheduler for this situation?
(I am sorry for being ignorant about it, there probably 
exists one).
If more than one process is using swap, they should use
it fairly. Put xjed's swap to rest for a moment, load the
swap due to X, and go forward.

My machine has 2 GB of swap area, both X and xjed swaps
could exist simultaneously without "having to wait to
long" for the other process business with swap to finish.

Please forgive me if I am being unfair about something,
I don't understand the internals of all this stuff.
That's why I first asked if having swap _not_ interfering
too much in other processes was impossible by some 
computer principle (like disks are not fast enough).

But it appears that it is something related to the
scheduling of what to read/write from/to swap and when.

Of course that's just what I think, and I would like
to learn more from knowleadgeble lkml people. Maybe
in trying to explain things to me, some hacker may
find that something could be made better, or point
me to some /sys tunnable which makes my experience
better.

