Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab0CINJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 08:09:12 -0500
Received: from bob75-7-88-160-5-175.fbx.proxad.net ([88.160.5.175]:43996 "EHLO
	cerbere.dyndns.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab0CINJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 08:09:09 -0500
From: Samir Bellabes <sam@synack.fr>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Rik van Riel <riel@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	<20100308094647.GA14268@elte.hu>
	<20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
	<4B9585BD.6070904@redhat.com>
	<alpine.LFD.2.00.1003081523280.3669@localhost.localdomain>
	<4B958D7F.1030900@redhat.com>
	<alpine.LFD.2.00.1003081555480.3669@localhost.localdomain>
	<4B95BFF6.5060503@schaufler-ca.com>
	<alpine.LFD.2.00.1003081955010.3669@localhost.localdomain>
Date: Tue, 09 Mar 2010 14:09:07 +0100
In-Reply-To: <alpine.LFD.2.00.1003081955010.3669@localhost.localdomain> (Linus
	Torvalds's message of "Mon, 8 Mar 2010 19:58:25 -0800 (PST)")
Message-ID: <m2pr3dlk0c.fsf@ssh.synack.fr>
User-Agent: Gnus/5.110003 (No Gnus v0.3) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 8 Mar 2010, Casey Schaufler wrote:
>> 
>> Those of you who say we ought to come up with a single framework
>> that we can use to Do The Right Thing haven't been reading the code.
>> We have such a framework in the LSM.
>
> .. and people are also interested in using (and expanding) the 'notify' 
> layer, probably because it is obviously designed for efficiently talking 
> at a user-level program about the relevant accesses. Whether that is 
> because they are just crazy ("malware detection") or whether it is an 
> indication that the LSM layer and current security models are just not 
> convenient enough, I dunno.

LSM layer gives enough to push the policy manager in userspace. Even
after that to a centralized server.

I worked on this, regarding networking. Next move should be to include
the LSM hooks regarding filesystem. [0]

I have concern about the way to do this, ie should we use the LSM layer
to do this, or should we put the features directly in the filesystem
stack or networking stack ?
At this point, it reminds me, ipchains (kernel 2.2) vs netfilter (kernel
2.4-2.6). At the beginning, with ipchains, filtering code was directly
in the network stack, and it wasn't the solution. So netfilter's hooks
was designed.

with LSM, we have a layer, and as sure as every one will come with his
own approach, I think we should keep code in stack (network, filesystem,
..) clean, and make the defering to userspace approach as a security
module. Then let the user/distro decided which features he want to use.

thanks,
sam

[0] http://lkml.org/lkml/2010/3/2/295
