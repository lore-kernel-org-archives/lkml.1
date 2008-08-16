Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYHPH2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYHPH2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 03:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYHPH2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 03:28:08 -0400
Received: from mail.lang.hm ([64.81.33.126]:33418 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbYHPH2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 03:28:06 -0400
Date: Sat, 16 Aug 2008 00:27:53 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Valdis.Kletnieks@vt.edu
cc: Arjan van de Ven <arjan@infradead.org>, Peter Dolding <oiaohm@gmail.com>,
       rmeijer@xs4all.nl, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       capibara@xs4all.nl, Eric Paris <eparis@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
In-Reply-To: <51467.1218864924@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.1.10.0808160014420.12859@asgard.lang.hm>
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl> <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com> <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm> <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>         
   <20080815210942.4e342c6c@infradead.org> <51467.1218864924@turing-police.cc.vt.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008, Valdis.Kletnieks@vt.edu wrote:

> Many security experts believe that a false sense of security is worse than
> no security at all.  In other words, unless the design team is *honest* with
> themselves about what the proposal does and doesn't cover, and has at least
> an *idea* of how the uncovered parts will function, you're not adding to
> the *real* security.

this is why there was so much preasure for them to define their threat 
model. they have donw so. if you disagree with that please suggest a 
different threat model rather then just listing various threats that their 
model doesn't cover.

> The problem with saying stuff like "Oh, our threat model explicitly rules
> out anything done by root" is that all too often, the other part of the
> overall plan - the one that constrains the root user - is never deployed.

it may not be appropriate to lock down root, it depends on what threats 
the box is under.

on the other hand, locking down root perfectly, but readily serving 
windows virii to other systems isn't good in some cases either.

security is not 'one size fits all'

> One of the proponents of the idea told me "so I don't see that as a big
> problem", when the problem in question (the race condition between malware
> arriving and actual scanning with a signature that detects the malware) is one
> of *THE* biggest issue for actual deployments of this sort of stuff.  No, TALPA
> doesn't have to necessarily deal with that race condition itself.

so how _so_ you handle detecting bad data before anyone defines it as bad?

remember, the 'bad data' may be a $propriatary_media format that only 
causes problems when run with $propriatary_software on $proptiatary_OS. Or 
the 'bad data' could be a document in an open format that complies with 
the specs of that format, but a common client doesn't handle the 
legitimate file correctly.

there is no possible way to detect these ahead of someone defineing them 
as bad. you can prevent them from being exploited on the Linux system (or 
limit the damage of the exploit), that's what SELinux aims at.

> But you damn sight well better have a good idea of how you intend to deal
> with it, because if you don't, the end result isn't actually usable for
> anything...

again, that's why the push for a threat model.

>> (nor should we do something that has no value.. but that's not the case;
>> the model that Erik described is quite well defined as
>> "do not give ''bad' content to applications/exec".
>
> The model is *not* "quite well defined" - because "bad content" is a rather
> squishy term (go read Fred Cohen's PhD thesis, where he shows that detecting
> viruses/malware is equivalent to the Turing Halting Problem).  What you
> *really* mean is "that subset of bad content that we can reasonably
> economically catch with pattern matching signatures".

more precisely the model is defined as "do not give 'unchecked' data to 
applications/exec" how they are checked is not defined, providing the 
hooks so that checking can be done is what we are trying to define.

> But yeah, trying to scan data before it's read, to detect some fraction of
> the known threats, *does* close a few holes.  The question is how does it
> fit in as "part of this complete security breakfast"...

one _very_ nice thing about the hooks currently being proposed is that 
they are useful for things besides anti-virus tools, tools that have no 
security implications at all. so even if there were no security benifit 
the hooks are still worth considering. but the fact is there is a threat 
model here that is not addressed well with other mechanisms, that is 
useful to cover.

David Lang
