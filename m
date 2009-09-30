Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbZI3Wto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbZI3Wto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZI3Wtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:49:43 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:52025 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZI3Wtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:49:42 -0400
X-Greylist: delayed 1145 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2009 18:49:42 EDT
Date: Thu, 1 Oct 2009 00:30:39 +0200
From: Herbert Poetzl <herbert@13thfloor.at>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
Message-ID: <20090930223039.GO484@MAIL.13thfloor.at>
Mail-Followup-To: Balbir Singh <balbir@linux.vnet.ibm.com>,
	Pavel Emelyanov <xemul@openvz.org>, bharata@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org,
	Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	Gautham R Shenoy <ego@in.ibm.com>,
	Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Avi Kivity <avi@redhat.com>, Chris Friesen <cfriesen@nortel.com>,
	Paul Menage <menage@google.com>, Mike Waychison <mikew@google.com>
References: <20090930124919.GA19951@in.ibm.com> <4AC35EDD.1080902@openvz.org> <20090930143820.GG3071@balbir.in.ibm.com> <4AC374E3.9000308@openvz.org> <20090930153053.GM3071@balbir.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930153053.GM3071@balbir.in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 09:00:53PM +0530, Balbir Singh wrote:
> * Pavel Emelyanov <xemul@openvz.org> [2009-09-30 19:10:27]:
> > Balbir Singh wrote:
> > > * Pavel Emelyanov <xemul@openvz.org> [2009-09-30 17:36:29]:
> > >> Bharata B Rao wrote:
> > >>> Hi,
> > >>>
> > >>> Here is the v2 post of hard limits feature for CFS group scheduler. This
> > >>> RFC post mainly adds runtime borrowing feature and has a new locking scheme
> > >>> to protect CFS runtime related fields.
> > >>>
> > >>> It would be nice to have some comments on this set!
> > >> I have a question I'd like to ask before diving into the code.
> > >> Consider I'm a user, that has a 4CPUs box 2GHz each and I'd like
> > >> to create a container with 2CPUs 1GHz each. Can I achieve this
> > >> after your patches?
> > > 
> > > I don't think the GHz makes any sense, consider CPUs with frequency
> > > scaling. If I can scale from 1.6GHz to say 2.6GHz or 2GHz to 4GHz,
> > > what does it mean for hard limit control? Hard limits define control
> > > over existing bandwidth, anything else would be superficial and hard
> > > hard to get right for both developers and users.
> > 
> > Two numbers for configuring limits make even less sense OTOH ;)
> > By assigning 2GHz for 4GHz CPU I obviously want half of its power ;)
> > Please, see my reply to vatsa@ in this thread.

> But it makes life more difficult for the administrator to think in
> terms of GHz -- no? Specifically with different heterogeneous systems.
> I think it would be chaotic in a data center to configure GHz for
> every partition. Not to say that it makes it even more confusing when
> running on top of KVM. Lets say I create two vCPUs and I specifiy GHz
> outside, do I expect to see it in /proc/cpuinfo?

> I'd like to hear what others think about GHz as well.

for me, using something like GHz or even BogoMips would
not make any sense whatsoever ... I would be able to
understand percentage, but this has some other implications
as it does not handle granularity ....

Linux-VServer uses interval and rate, which is very similar
to your setup, except that we use two pairs to achive
a differentiation for 'busy' and 'idle' cases, i.e. when
the cpu(s) would go idle, we switch from R1/I1 to R2/I2
for all guests, allowing to distribute the excess differently
than the 'active' part ... but only one set is needed for
hard limits ...

best,
Herbert

> -- 
> 	Balbir
