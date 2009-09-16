Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbZIPUbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbZIPUbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbZIPUbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:31:39 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59922 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbZIPUbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:31:38 -0400
Date: Wed, 16 Sep 2009 22:31:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: tabbott@ksplice.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, geofft@ksplice.com
Subject: Re: [PATCH v2] sparc: Clean up linker script using new linker
	script macros.
Message-ID: <20090916203141.GB17153@merkur.ravnborg.org>
References: <1253119592-19598-2-git-send-email-tabbott@ksplice.com> <20090916.101924.186960949.davem@davemloft.net> <alpine.DEB.1.10.0909161322260.2942@dr-wily.mit.edu> <20090916.103019.253722423.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916.103019.253722423.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 10:30:19AM -0700, David Miller wrote:
> From: Tim Abbott <tabbott@ksplice.com>
> Date: Wed, 16 Sep 2009 13:27:43 -0400 (EDT)
> 
> > On Wed, 16 Sep 2009, David Miller wrote:
> > 
> >> Can you do this cleanup without moving the relative locations of .data
> >> and .data1 sections?
> > 
> > Yes, if you just swap RW_DATA_SECTION and .data1 so it looks like
> > 
> > RW_DATA_SECTION(SMP_CACHE_BYTES, 0, THREAD_SIZE)
> > .data1 : {
> > 	*(.data1)
> > }
> > 
> > instead, that would preserve their relative locations.
> > 
> > Currently, switching to RW_DATA_SECTION would still result in a change in 
> > their relative position that .data.page_aligned and .data.nosave would be 
> > between .data and .data1 (not sure if that is relevant on sparc). (this 
> > will change when <http://lkml.org/lkml/2009/9/16/396> is merged).
> 
> I don't know which, if any, are relevant or could cause problems.
> 
> It's hard for me to ACK this because it's not a straight nop
> transformation, which we could at least presume would function
> properly if the macros were implemented correctly.

As you most likely are aware the linker scripts has diverged a lot
over time between different architectures.
So whatever fits the ordering of one architecture fails on another
architecture.

Tim is doing a huge effort to bring some sanity into this
area which I appreciate a lot!

	Sam
