Return-Path: <linux-kernel-owner+w=401wt.eu-S1761764AbZDCIPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761764AbZDCIPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759359AbZDCIOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:14:42 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:62949 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761444AbZDCIOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:14:38 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNbXapXix8oF
X-RZG-CLASS-ID: mo05
Message-ID: <49D5C564.5030904@ursus.ath.cx>
Date: Fri, 03 Apr 2009 10:14:28 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Ray Lee <ray-lk@madrabbit.org>, david@lang.hm,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
References: <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <2c0942db0904021307w2c311dc2s9bf31c9ed3c1e6ba@mail.gmail.com> <49D5273B.60806@ursus.ath.cx> <20090402233806.GG9870@mit.edu>
In-Reply-To: <20090402233806.GG9870@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03.04.2009 01:38 Theodore Tso wrote:
> On Thu, Apr 02, 2009 at 10:59:39PM +0200, Andreas T.Auer wrote:
>> Yes, but a lot of users (and I assume >90% of POP3 users) don't use this
>> option.
>>
> 
> Sometimes, the filesystem isn't the best place to solve all problems.  

Surely you cannot solve all problems in the filesystem. Especially the
delay-spin-up vs. keep-all-important-recent-data problem simply can't be
done by the filesystem. It can't be done by the application either,
because it is the decision of the user, which data are important enough
to do a spin-up. But it's not possible to tell the filesystem, which
applications should spin-up at fsync(). And even within applications
there are differences between the love-mail from the girl you met
recently and the love-mail from that "russian girl", which isn't a girl,
but just a bunch of fraudsters.

> What's been frustrating about this whole controversy is this implicit
> assumptions that users and applications should never change, and the
> filesystem should magically accomodate and Do The Right Thing.

It's not that they should never change, it's that you can't expect them
to change. There are just a few filesystems in the kernel and you need
some level of competence to maintain the code or contribute to it. But
you have no such filter in the application world, which is much much
bigger than the controlled area of the kernel. The application can be
crappy and would still have its users as long there is no better
alternative for a special task. Even after the project is orphaned it
still can be used by the users. I had such a tool to get the log data
out of my PBX. It was orphaned long before and it had no alternative.

> If you're *never* going want to risk ever losing mail, then fine,
> fsync() it to disk before you send the POP3 DELETE command.

The *user* wants his data safe, but the *application* has to decide
whether or not to fsync(). Well, in case of a POP3 client fsync() should
be common sense before a DELETE.

> The problem is, this is what the application programmers are telling
> the filesystem developers. They refuse to change their programs; and
> the features they want are sometimes mutually contradictory, or at
> least result in a overconstrained problem --- and then they throw the
> whole mess at the filesystem developers' feet and say, "you fix it!"

I think the users are complaining more than the application developers.
If the application developers would complain for their piece of
software, they would probably be smart enough to change their code using
some new function calls (like barrier() or whatever). But the problem
are the non-complaining developers that simply don't have a clue about
all this.

> I'm not saying the filesystems are blameless, but give us a little
> slack, guys; we NEED some help from the application developers here.

You have to find a _reasonable_ default integrity/performance trade-off
for those applications that are not aware of the filesystem levels. "I
just write out the data to disk with fprintf()."

For laptop-mode a global reasonable default doesn't seem to exist, so a
"perfect system" would have the possibility to tell the users, which
applications triggered a spin-up and provide the users with methods to
suppress/fine-tune the spin-up for the applications he wants to. The
distros could pre-configure it to some reasonable defaults for each
application.

Andreas
