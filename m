Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbXFVFHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbXFVFHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXFVFHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:07:30 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:50673
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbXFVFH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:07:29 -0400
Date: Thu, 21 Jun 2007 22:07:27 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Joshua Brindle <method@manicmethod.com>
cc: Lars Marowsky-Bree <lmb@suse.de>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <467B45E0.3040207@manicmethod.com>
Message-ID: <Pine.LNX.4.64.0706212158060.9657@asgard.lang.hm>
References: <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com>
 <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz>
 <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz>
 <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
 <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
 <20070621211743.GN20105@marowsky-bree.de> <467B14D9.8050000@manicmethod.com>
 <Pine.LNX.4.64.0706211722440.31603@asgard.lang.hm> <467B45E0.3040207@manicmethod.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Joshua Brindle wrote:

> david@lang.hm wrote:
>>  On Thu, 21 Jun 2007, Joshua Brindle wrote:
>> 
>> >  Lars Marowsky-Bree wrote:
>> > >   On 2007-06-21T16:59:54, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>> > >   <snip>
>> > > 
>> > > 
>> > > >   Um, no.  It might not be able to directly open files via that 
>> > >  path, but
>> > > >   showing that it can never read or write your mail is a rather 
>> > >  different
>> > > >   matter.
>> > > > 
>> > >   Yes. Your use case is different than mine.
>> > > 
>> > 
>> >  So.. your use case is what? If an AA user asked you to protect his mail 
>> >  from his browser I'm sure you'd truthfully answer "no, we can't do that 
>> >  but we can protect the path to your mail from your browser".. I think 
>> >  not. One need only look at the wonderful marketing literature for AA to 
>> >  see what you are telling people it can do, and your above statement 
>> >  isn't consistent with that, sorry.
>>
>>  remember, the policies define a white-list
>> 
>
> Except for unconfined processes.

correct, but we are talking about what a confined process can get to 
without assistance from an unconfined process.

>>  so if a hacker wants to have mozilla access the mail files he needs to get
>>  some other process on the sysstem to create a link or move a file to a
>>  path that mozilla does have access to. until that is done there is no way
>>  for mozilla to access the mail through the filesystem.
>>
>>  other programs could be run that would give mozilla access to the mail
>>  contents, but it would be through some other path that the policy
>>  permitted mozilla accessing in the first place.
>> 
> Or through IPC or the network, that is the point, filesystem only coverage 
> doesn't cut it; there is no way to say the browser can't access the users 
> mail in AA, and there never will be.

AA can be extended to cover these things in the future.

remember 'release early release often'?
how about 'perfect is the enemy of good enoug'?

at this point they're trying to get the initial implementation in so that 
people can start takeing advantage of it. As a side effect the cost of 
maintaining it will decrease, and they can put effort into planning future 
enhancements.

besides, as far as the network communication goes, doesn't netfilter now 
have a way to make rules for specific processes? if they don't then it 
could be added, but the details of the implementation would probably be 
very different from the current AA file controls.

how does delaying the acceptance of the current implementation encourage 
the additional features being added?

but to answer your two comments.

how does mozilla access your mail over the network without first capturing 
your password from somewhere?

as far as IPC goes, unix sockets are unavailable (AA as-is will control 
them), so you must be talking about signals or shared memory as the IPC 
mechanisms that mozilla would use to access your mail.

please explain to me what mail client you are useing that exposes your 
mail via these mechinsms.

David Lang
