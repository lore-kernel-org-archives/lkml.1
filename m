Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZFYMif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZFYMif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZFYMi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:38:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34273 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZFYMiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:38:25 -0400
Date: Thu, 25 Jun 2009 15:37:57 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
Message-ID: <20090625123757.GA7121@redhat.com>
References: <20090623150008.GA21059@redhat.com> <4A4184C3.6060503@novell.com> <20090624084901.GB22865@redhat.com> <20090625110812.GA6487@redhat.com> <4A435F28.3000301@novell.com> <20090625115403.GA7079@redhat.com> <4A4368A4.8030401@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4368A4.8030401@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 08:08:04AM -0400, Gregory Haskins wrote:
> The patch has been in circulation for weeks, is well tested/reviewed
> (and I hope its considered well written), and I want to get on with my
> life ;).

Hey, I feel your pain, I've been reviewing these ..

> Your proposal doesn't change the user->kern ABI, so any
> consolidation will be just an internal change to the kernel code only. 
> People can start using the interface today to build things, and we can
> fix up the internal code later once your proposals have had a chance to
> be shaped after review, etc (which I know from experience can take a
> while and change radically though the course ;).
> 
> IOW: The only thing waiting does is hide the history of the edit, since
> whatever change is proposed is invariably the same amount of work for me
> to convert it over.  Its purely a question of whether its folded into
> the history or visible as two change records.  Based on that. I don't
> see any problem with it just going in now.  Its certainly ready from my
> perspective.
> 
> So I guess the question is: What's your objection?

No objections, only comments ;)

> (BTW: I am talking about the yet unpublished "v9" which addresses all
> your other comments sans the io_bus interface changes.

I thought we agreed on the io_bus approach. What changed?

>  Will push out
> later today)

BTW, is the group removal race handled there somehow?
Here's what I have in mind:
kvm does
	lock
	dev = find
	unlock

	<---------- at this point group device is removed

	write access to device that has been removed


-- 
MST
