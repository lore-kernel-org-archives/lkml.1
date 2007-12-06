Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbXLFGFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbXLFGFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 01:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXLFGF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 01:05:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751262AbXLFGF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 01:05:29 -0500
Date: Wed, 5 Dec 2007 23:04:46 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: renzo@cs.unibo.it (Renzo Davoli)
Cc: linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
Message-ID: <20071205230446.5487f4b5@shemminger-laptop>
In-Reply-To: <20071206053821.GB1464@cs.unibo.it>
References: <20071205164055.GA2082@cs.unibo.it>
	<20071205165552.3fc96dae@shemminger-laptop>
	<20071206053821.GB1464@cs.unibo.it>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 06:38:21 +0100
renzo@cs.unibo.it (Renzo Davoli) wrote:

> On Wed, Dec 05, 2007 at 04:55:52PM -0500, Stephen Hemminger wrote:
> > On Wed, 5 Dec 2007 17:40:55 +0100
> > renzo@cs.unibo.it (Renzo Davoli) wrote:
> > > 0- (Constructive) comments.
> > > 1- The "official" assignment of an Address Family.
> > > 2- Another "grabbing hook" for interfaces (like the ones already
> > > We are studying some way to register/deregister grabbing services,
> > > I feel this would be the cleanest way. 
> > 
> > Post complete source code for kernel part to netdev@vger.kernel.org.
> I'll do it as soon as possible.
> > If you want the hooks, you need to include the full source code for inclusion
> > in mainline. All the Documentation/SubmittingPatches rules apply;
> > you can't just ask for "facilitators" and expect to keep your stuff out of tree.
> I am sorry if I was misunderstood.
> I did not want any "facilitator", nor I wanted to keep my code outside
> the kernel, on the contrary.

Greate

> It is perfectly okay for me to provide the entire code for inclusion.
> The purposes of my message were the following:
> - I wanted to introduce the idea and say to the linux kernel community
>   that a team is working on it.
> - Address family: is it okay to send a patch that add a new AF?
> is there a "AF registry" somewhere? (like the device major/minor
> registry or the well-known port assignment for TCP-IP).

The usual process is to just add the value as part of the patchset.
You then need to tell the glibc maintainers so it gets included appropriately
in userspace.

> - Hook: we have two different options. We can add another grabbing
> inline function like those used by the bridge and macvlan or we can
> design a grabbing service registration facility. Which one is preferrable?

The problem with making it a registration facilties are:
 * risk of making it easier for non-GPL out of tree abuse
 * possible ordering issues: ie. by hardcoding each hook, the
    behaviour is defined in the case of multiple usages on the same
    machine.

> The former is simpler, the latter is more elegant but it requires some 
> changes in the kernel bridge code.

Not a big deal, but see above

> So the former choice is between less-invasive,safer,inelegant, the
> latter is more-invasive,less safe,elegant.

 
> We need a bit of time to stabilize the code: deeply testing the existing
> features and implementing some more ideas we have on it.
> In the meanwhile we would be grateful if the community could kindly ask to the
> questions above.

I am a believer in review early and often. It is easier to just deal with
the nuisance issues (style, naming, configuration) at the beginning rather
than the final stage of the project.
