Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbXJCKnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbXJCKnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbXJCKnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:43:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43370 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbXJCKne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:43:34 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com
In-Reply-To: <1191406506.4093.35.camel@lov.localdomain>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
	 <200710022205.05295.nickpiggin@yahoo.com.au>
	 <1191406506.4093.35.camel@lov.localdomain>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 12:37:52 +0200
Message-Id: <1191407872.5572.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-03 at 12:15 +0200, Kay Sievers wrote:
> On Tue, 2007-10-02 at 22:05 +1000, Nick Piggin wrote:
> > On Tuesday 02 October 2007 21:40, Peter Zijlstra wrote:
> > > On Tue, 2007-10-02 at 13:21 +0200, Kay Sievers wrote:
> > 
> > > > How about adding this information to the tree then, instead of
> > > > creating a new top-level hack, just because something that you think
> > > > you need doesn't exist.
> > >
> > > So you suggest adding all the various network filesystems in there
> > > (where?), and adding the concept of a BDI, and ensuring all are properly
> > > linked together - somehow. Feel free to do so.
> > 
> > Would something fit better under /sys/fs/? At least filesystems are
> > already an existing concept to userspace.
> 
> Sounds at least less messy than an new top-level directory.
> 
> But again, if it's "device" releated, like the name suggests, it should
> be reachable from the device tree.
> Which userspace tool is supposed to set these values, and at what time?
> An init-script, something at device discovery/setup? If that is is ever
> going to be used in a hotplug setup, you really don't want to go look
> for directories with magic device names in another disconnected tree.

Filesystems don't really map to BDIs either. One can have multiple FSs
per BDI.

'Normally' a BDI relates to a block device, but networked (and other
non-block device) filesystems have to create a BDI too. So these need to
be represented some place as well.

The typical usage would indeed be init scripts. The typical example
would be setting the read-ahead window. Currently that cannot be done
for NFS mounts.



