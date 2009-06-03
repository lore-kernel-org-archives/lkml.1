Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZFCFWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZFCFWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 01:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbZFCFWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 01:22:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43531 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbZFCFWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 01:22:35 -0400
Date: Wed, 3 Jun 2009 01:22:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Dan Magenheimer <dan.magenheimer@oracle.com>
cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, avi@redhat.com,
       xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir Fraser <Keir.Fraser@eu.citrix.com>,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, xen-users@lists.xensource.com,
       ksrinivasan <ksrinivasan@novell.com>, EAnderson@novell.com,
       wimcoekaerts@wimmekes.net, Stephen Spector <stephen.spector@citrix.com>,
       jens.axboe@oracle.com, npiggin@suse.de
Subject: RE: Merge Xen (the hypervisor) into Linux
In-Reply-To: <3ab07e3b-a601-48d5-b350-29cbaf111892@default>
Message-ID: <alpine.DEB.2.00.0906030108500.14994@gandalf.stny.rr.com>
References: <3ab07e3b-a601-48d5-b350-29cbaf111892@default>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2 Jun 2009, Dan Magenheimer wrote:

> > > On Tue, Jun 02, 2009 at 05:00:21PM -0700, Dan Magenheimer wrote:
> > > > That sound you heard was 10000 xen-users@lists.xensource.com
> > > > all having heart attacks at once.
> > > > 
> > > > Need I say more.
> > > 
> > > So maybe I'm stupid, but why would they be having heart attacks?
> > 
> > Maybe because they asked for an apple and got an apple pie?
> > 
> > That is, they are pushing hard for an interface for Dom0, and 
> > Ingo just 
> > agreed to take it along with the entire Xen hypervisor ;-)
> 
> Um, no, he did not.  He and Avi suggested that Xen be completely
> rearchitected to suit Linux's preferences. 

I was being a bit tongue in cheek with that comment too.

> 
> A hypervisor is not an operating system.

You say potato I say potato (Hmm, that doesn't work in text)

>  Yes there is
> similarity in a number of pieces of code.  But there's
> some similarity between Java and Linux too...

Java can run on hardware?

> 
> > Perhaps the rightful place for the Xen hypervisor is in 
> > Linux. Xen 
> > is GPL right? Thus we could do this even with out the permission from 
> > Citrix.
> 
> (tongue firmly in cheek in case you might assume otherwise)
> Linux is GPL right?  Perhaps the rightful place for the Linux
> operating system is part of Java.  Thus we could do this even
> with out the permission from Ingo.

If Java became GPL it could very well do that.

> 
> > I just don't see 
> > the Xen team cooperating with the Linux team.  But maybe those 
> > are the old days. 
> 
> Yes, let's fix that.  Let's start turning this discussion towards
> how we can cooperate better.

Sure.

> 
> > The Dom0 push of Xen just seems too much like Linux being Xen's sex 
> > slave, when it should be the other way around.
> 
> I can certainly see how it might feel that way, but it needn't
> be... nor the other way around.  But in the end, only the end users
> matter.  If we can't cooperate, we simply cede the war to Windows
> and Hyper-V.

When I suggest that Xen be merged into Linux, I did not mean it had to be 
like KVM or lguest where the Linux would boot up and run Xen. I mean that 
Xen could still be a micro kernel. The difference would be that its source 
would live in the kernel proper. linux.git/xen?   This way the ABI between 
Xen and Dom0 would always be in sync.

We could even link it in to the vmlinuz, instead of needing the separate 
xen.gz to load first. The vmlinuz could then expand into a Xen 
hypervisor, and also load the Dom0 with it. One image for both entities.

If you want Dom0 ABI in, you have to expect it to change without notice. 
If this breaks Xen, then we don't want to hear any complaints. This means 
that users of Xen would need to make sure that they have both the most 
recent on hypervisor and kernel and hope that they match.

With the combined image we then get the two to always be together, and no 
problems with the users.

What's the issue with this? You get to keep your "micro hypervisor" design 
that has been stated to be the superior method.

-- Steve

