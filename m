Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbXJ0FQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbXJ0FQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 01:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXJ0FQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 01:16:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55417 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbXJ0FQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 01:16:26 -0400
Date: Fri, 26 Oct 2007 22:16:24 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071026221624.cec512da.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710261949360.30293@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<20071025185506.8c373aa8.pj@sgi.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	<1193412644.5032.13.camel@localhost>
	<alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	<20071026120037.7b95a136.pj@sgi.com>
	<alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	<1193433239.5032.95.camel@localhost>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<Pine.LNX.4.64.0710261949360.30293@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still confused, Christoph.

Are you saying:
 1) The kernel continues to default to Choice A, unless
    the flag enables Choice B, or
 2) The kernel defaults to the new Choice B, unless the
    flag reverts to the old Choice A?

Alternative (2) breaks libnuma and hence numactl until it is changed
to use the flag, or changed to use choice B (in which case it wouldn't
need the flag.)

So I guess you mean alternative (1) above, since you seem to be taking
the position that we can't break compatibility here.

But I could quote statements from you that seem to clearly state the
exact opposite.

So I remain confused.

Actually, alternative (1) is kinda ugly.  It leaves a permanent wart
on the set_mempolicy API -- two different variants to what the node
numbers and node masks mean, depending on whether this MPOL_MF_RELATIVE
is set on each call.  We'll have to ship out an extra serving of brain
food for most folks looking at this to have much chance that they will
confidently understand the difference between the two options selected
by this flag.

I wonder if there might be some way to avoid that permanent ugly wart
on each and every set/get mempolicy system call forever afterward.

Please try to double check your next reply, Christoph.  I'm beginning
to worry that we might be failing to communicate clearly.  Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
