Return-Path: <linux-kernel-owner+w=401wt.eu-S2992522AbXDROGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992522AbXDROGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992531AbXDROGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:06:01 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2216 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992522AbXDROF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:05:59 -0400
Message-ID: <12573.213.222.28.155.1176905146.squirrel@webmail.xs4all.nl>
In-Reply-To: <46260BE1.4060509@tresys.com>
References: <20070416213350.GB4030@suse.de>
    <Line.LNX.4.64.0704161846110.13905@d.namei>
    <1176846917.5946.79.camel@localhost.localdomain>
    <19259.213.222.28.155.1176880873.squirrel@webmail.xs4all.nl>
    <46260BE1.4060509@tresys.com>
Date: Wed, 18 Apr 2007 16:05:46 +0200 (CEST)
Subject: Re: AppArmor FAQ
From: "Rob Meijer" <capibara@xs4all.nl>
To: "Joshua Brindle" <jbrindle@tresys.com>
Cc: capibara@xs4all.nl, "Karl MacMillan" <kmacmill@redhat.com>,
       "James Morris" <jmorris@namei.org>, "John Johansen" <jjohansen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Reply-To: capibara@xs4all.nl
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, April 18, 2007 14:15, Joshua Brindle wrote:

>> Having said that, I feel a path based solution could have great
>> potential
>> if it could be used in conjunction with the object capability model,
>> that
>> I would consider a simple and practical alternative integrity model that
>> does not require lables in an MLS maner, and that extends on the POLP
>> concept in a way that would be largely more practical.
>>
> This would be combining two bad systems to get a worse one IMO.
> Capability systems are inherently discretionary since propagated
> capabilities must be removed at the discretion of the possessor of the
> capabilities.

That is assuming there is no caretaker or membrane implementation in the
delegation chain, but I don't think we need to get into such details of
object capabilities here. Point is there are ways to delegate revocable
capabilities when using the OC model when required.

> The argument that labels are not practical has yet to be shown but is
> thrown around as if it is fact. Path based systems are inferior to label
> based systems based if for no other reason than path based systems can't
> control transient objects. With policy based type transition in SELinux
> when my ssh client writes my agent socket to /tmp/ssh-xxxxxxxxxx SELinux
> calculates a type transition based off my domain to label it
> sysadm_ssh_t (or whatever is appropriate) whereas path based systems
> can't possibly control access to these objects. The same goes for any
> files written to home directories by user apps.

I fully agree that path based security is inferior 'when used on its own'.

>> That is, using 'thin' path based profiles would become very practical if
>> all further authority can be communicated using handles in the same way
>> that an open file handle can be communicated.
>>
>
> Once again, this creates a discretionary system that would not work
> without modifying every single application that uses such authority

It creates a discretionary enviroment that makes it much more natural
for developers to create cooperating subsystems that are designed
from an least authority perspective. And it creates the means to
configure the system for such programs with a minimum amounth of
profile information.

Next to this, but a bit more complicated, path based security could in
theory be used to make required authority explicitly designated. That is
calling :

  cp ~/foo.txt ~/bar_directory/

could ultimately explicitly transfer the user his authorities to both
~/foo.txt and ~/bar_directory/ to this instance of 'cp', but without
transfering any other ambient authority. This example may be a bit
out of the current range for AppArmor, but I feel it demonstrates that
path based security may have potential added value in a least authority
context.

That is if Allice has authority to ~/, and ~/ contains ~/important.doc
and allice has rw access to ~/important.doc, than ultimately invoking 'cp
~/foo.txt ~/bar_directory/' should not give the 'cp' instance the
authority to read/write ~/important.doc, but invoking 'cp ~/foo.doc
~/important.doc'
should. That is, if we want cp to work unmodified.

> (and
> trusting the code is bug free so that it does the right thing)

I think the abouve shows that it actualy requeres 'less' trust in
code if implemented right.

> and gives
> you an inflexible, decentralized, unmaintainable, unanalyzable policy
> since it is distributed throughout code all over the system, you give
> users no way to change the security characteristics of the system.

I agree with the decentralized part, but in my view accomodating and
allowing free and optionaly revocable delegation (you can always proxy
anyway, so we know blocking it is misguided) makes for a much more
flexible and esspecialy usable form of security.
Systems designed according to POLA are definetely the most easy to
do formal analysis of security properties on.

I am not saying that path-based + OC would be 'better' than label based,
I feel both would have their own level of granularity where they are
usefull, and in some cases they could be complementary.

I feel path based would be useless when possitioned purely as MAC, but
when possitioned more as least authority bootstrap and designation
mechanism complementary to least authority design ant usage of the OC model,
I think path based may have some concrete use.

sidenote: it is amusing to see that many OC advocates use many of your
arguments (inflexible, unmaintainable, hard to analyze) to dismiss many
label based MLS models as viable security models;-)

Rob



