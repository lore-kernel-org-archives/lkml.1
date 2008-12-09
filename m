Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbYLIRjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbYLIRjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYLIRjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:39:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35067 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbYLIRjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:39:00 -0500
Date: Tue, 9 Dec 2008 12:37:03 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Jan Rekorajski <baggins@sith.mimuw.edu.pl>
Cc: linux-kernel@vger.kernel.org, Holger Hoffstaette <holger@wizards.de>,
       netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <greg@kroah.com>, stable@kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
Message-ID: <20081209123703.043067eb@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20081208222246.GA29232@sith.mimuw.edu.pl>
References: <pan.2008.12.08.06.18.57.357875@wizards.de>
	<200812080834.22924.rjw@sisk.pl>
	<pan.2008.12.08.08.07.29.439625@wizards.de>
	<493D4F5C.7020606@s5r6.in-berlin.de>
	<493D7349.10200@s5r6.in-berlin.de>
	<20081208222246.GA29232@sith.mimuw.edu.pl>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008 23:22:46 +0100
Jan Rekorajski <baggins@sith.mimuw.edu.pl> wrote:

> On Mon, 08 Dec 2008, Stefan Richter wrote:
> 
> > >>> On Monday, 8 of December 2008, Holger Hoffstaette wrote:
> > >>>> The system is a generic old single-core P4 box with a single SATA drive,
> > >>>> Gentoo userland and Samba is 3.0.33 (in async mode). The kernel has no
> > >>>> patches or binary drivers.
> > 
> > Holger, it may be unrelated to the issue, but to be sure:  Which network
> > card driver do you use?
> 
> I think you can safely rule out NIC, I'm also seeing this behaviour on a
> brand new server with imap hanging in some busy-loop.
> Network card in my case:
> Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> 
> What I observer was one CPU doing 100% system work, and the number of
> timer interrupts went from 1k per second to 4k (for the whole system).
> 

Try reverting the idr patch that went into 2.6.27.8. It broke DRM in the
Fedora kernel at least.

http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.27.8/lib-idr.c-fix-rcu-related-race-with-idr_find.patch;h=b1145766fb9460a0c0285350b49216355c5b4ad8
