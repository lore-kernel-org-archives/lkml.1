Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYBMC74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYBMC74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYBMC7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:59:48 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51955 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751106AbYBMC7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:59:48 -0500
Date: Tue, 12 Feb 2008 20:59:44 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
Message-Id: <20080212205944.86ab2dc7.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802121832520.29792@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<1202861432.4974.29.camel@localhost>
	<20080212183158.3ff4ccd5.pj@sgi.com>
	<Pine.LNX.4.64.0802121702431.11628@schroedinger.engr.sgi.com>
	<20080212193229.edbff05a.pj@sgi.com>
	<alpine.DEB.1.00.0802121755400.23110@chino.kir.corp.google.com>
	<20080212202201.a534cef8.pj@sgi.com>
	<alpine.DEB.1.00.0802121832520.29792@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I do not subscribe to the theory that just because we have a couple extra 
> bytes of space somewhere in struct mempolicy that we have to use it 
> immediately.

Good grief ... I'm not lobbying for separate flag fields because the
space is there.  I was just dealing with one possible obection, by
noting that it wouldn't cost us in terms of struct mempolicy size.

> It makes the kernel code simpler, in a way.
> 
> Now we only have to pass a single actual among functions that include both 
> the mode and optional flags (there are a lot of them and they span not 
> only the VM but also filesystem code).

This gets closer to the key issue.

We both agree we want "simpler", but disagree on what that means.

We don't measure complexity -solely- by counting the size of parameter lists.
If we did that, we'd be packing all manner of sub-integer fields into single
'int' parameters.

I tend to measure complexity a level up from the bits and bytes,
and more in terms of how I think about things.  If I think of a routine
as taking two values, such as in this case an mempolicy mode (such as
MPOL_BIND or MPOL_INTERLEAVE) and this new flag (MPOL_F_STATIC_NODES),
which have a different sort of affect.

==> If each time I look at some 'flags' field, I have to think of it
as a couple of things glued together that I will have to pick apart to
use, that's more mental work than seeing those two things explicit and
separate, through most of the mempolicy.c code <==

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
