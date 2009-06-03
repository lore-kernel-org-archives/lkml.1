Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZFCMD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZFCMD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 08:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbZFCMDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 08:03:51 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:47765 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbZFCMDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 08:03:51 -0400
X-IronPort-AV: E=Sophos;i="4.41,298,1241395200"; 
   d="scan'208";a="5560757"
Message-ID: <4A2666A7.4060603@eu.citrix.com>
Date: Wed, 03 Jun 2009 13:03:51 +0100
From: George Dunlap <george.dunlap@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       "jeremy@goop.org" <jeremy@goop.org>, "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Merge Xen (the hypervisor) into Linux
References: <3ab07e3b-a601-48d5-b350-29cbaf111892@default> <alpine.DEB.2.00.0906030108500.14994@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0906030108500.14994@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2009 12:03:51.0959 (UTC) FILETIME=[5C520270:01C9E443]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> What's the issue with this? You get to keep your "micro hypervisor" design 
> that has been stated to be the superior method.
>   
It is a very interesting idea, but it would still be basically a 
completely new project.  If someone started such a project, they could 
probably cannibalize a lot of Xen's existing code (a funny boomerang, 
since Xen cannibalized Linux's code when it started), but it would still 
require a lot of work and re-writing, and the result would be a lot 
different than Xen is now.  It would be years before it was ready to be 
used in a production system.  It's not really realistic to expect all 
the Xen developers and users to drop Xen development, shift gears into 
this new project, and wait until it's ready to be used.  (That's not to 
say that the idea has no merit, just that Xen as it is wouldn't go away 
until it this hypothetical linux hypervisor component was mature enough 
for users and developers to jump onto.)

Yeah, lots of interesting implications for such a project.

Having a separate component to be a hypervisor, even if in the same 
tree, would mean we could have dedicated hypervisor schedulers, &c.  
They could (conceivably) work more closely with the dom0 scheduler to 
make things more efficient.

As others have said, it would limit the ability of such a hypervisor to 
be used with other dom0 operatings systems.  Fixing the ABI sufficiently 
so that others can use it might be possible, but it seems to me unlikely 
to meet with much success without a lot of committment on both sides 
(i.e., w/in Linux and within other OS communities).

I'm not sure that it would turn out quite the way some people expect, 
though.  From a technical perspective, I'm not sure getting rid of the 
"ring 1 hack" or requiring HVM support would be the best design choice 
for such a project.  And it's hard to predict what kinds of technical, 
political, or cultural issues, directions, or potential dead-ends a 
project might take. 

 From all angles, it's too risky to just abandon the current Xen 
codebase until this hypothetical linux hypervisor component has shown 
itself to be viable.

-George
