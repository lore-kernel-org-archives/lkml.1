Return-Path: <linux-kernel-owner+w=401wt.eu-S2992856AbXDYSgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992856AbXDYSgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992878AbXDYSgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:36:54 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49093 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992856AbXDYSgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:36:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       mst@mellanox.co.il, jackm@mellanox.co.il
Subject: Re: pgprot_writecombine() and PATs on x86
References: <ada1wi8xrgt.fsf@cisco.com> <200704252019.28017.ak@suse.de>
Date: Wed, 25 Apr 2007 12:31:34 -0600
In-Reply-To: <200704252019.28017.ak@suse.de> (Andi Kleen's message of "Wed, 25
	Apr 2007 20:19:27 +0200")
Message-ID: <m1abwws3uh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> On Wednesday 25 April 2007 20:02:26 Roland Dreier wrote:
>> Hi Eric,
>> 
>> Where do your patches to add an implementation of
>> pgprot_writecombine() using PATs on x86 stand?  
>
> It's on my todo list.

Basically enabling PAT is easy.  Adding the paranoid checks is
trickier.  I keep intending to do something but...

>> The mlx4 driver I'm 
>> planning on merging for 2.6.22 would really like writecombining, and
>> I'm interested in doing the work to finally get the PAT stuff merged
>> (probably for 2.6.23 I guess).
>> 
>> Just to give a little background on my motivation: the mlx4 hardware
>> allows a page in its PCI space to be mapped, where the driver can write
>> descriptors and payloads directly, instead of ringing a doorbell and
>> having the HW fetch the descriptor from system memory, for better latency.
>
> When it's PCI space you can likely just use MTRRs. PAT is mostly useful
> for applications that do IO with random memory pages

The problem is that on machines with larger memory configurations (8-12G)
there are no spare mtrrs, or the mtrrs can frequently be configured in
an overlapping way so that we can't set them up.   In general mtrrs
work ok for one card possible for two and after that they are just
useless.

PAT is also much easier to use from a driver perspective, and it is
much more portable between architectures.  Using mtrrs from drivers
is almost impossible.

Roland is the mlx4 sane enough to put the memory that needs
write-combining a prefetchable bar.  So several cards can be combined
together?

Eric
