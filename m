Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZFYJTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZFYJTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZFYJTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:19:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38137 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbZFYJTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:19:37 -0400
Date: Thu, 25 Jun 2009 11:19:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve lpage NUMA support
Message-ID: <20090625091939.GS6760@one.firstfloor.org>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <20090625000202.GR6760@one.firstfloor.org> <4A42C131.6040007@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A42C131.6040007@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 05:13:37PM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> > 
> > Haven't read the new patches, but per cpu data always was sized
> > for all possible CPUs.
> > 
> >> and N is large, what did it cost?
> > 
> >> And what are reasonable values of N?
> > 
> > N should normally not be large anymore, since num_possible_cpus() 
> > is sized based on firmware information now.
> > 
> 
> *Ahem* virtual machines *ahem*...

And? Even there's not that big typically. 

The traditional problem was just for 128 NR_CPUs kernel were nothing
was sized based on machine capacity.

Also on large systems the VMs shouldn't be sized for full capacity.

> 
> I have discussed this with Tejun, and the plan is to allocate the percpu
> information when a processor is first brought online (but not removed
> when it is offlined again.)  It's a real problem for 32-bit VMs, so it's
> more important than you'd think.

You have to rewrite all code that does for_each_possible_cpu (x) 
in initialization then to use callbacks. It would be a gigantic change
all over the tree.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
