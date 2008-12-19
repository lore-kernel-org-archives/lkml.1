Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbYLSP10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbYLSP10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 10:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYLSP1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 10:27:18 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48227 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750837AbYLSP1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 10:27:17 -0500
Date: Fri, 19 Dec 2008 10:27:08 -0500
From: Theodore Tso <tytso@mit.edu>
To: Hannes Reinecke <hare@suse.de>
Cc: Seewer Philippe <philippe.seewer@bfh.ch>, Bernhard Walle <bwalle@suse.de>,
       Christoph Hellwig <hch@infradead.org>, initramfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Dave Jones <davej@redhat.com>, cjwatson@ubuntu.com,
       Bernhard Walle <bwalle@novell.com>
Subject: Re: Dracut -- Cross distribution initramfs infrastructure
Message-ID: <20081219152708.GE9871@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Hannes Reinecke <hare@suse.de>,
	Seewer Philippe <philippe.seewer@bfh.ch>,
	Bernhard Walle <bwalle@suse.de>,
	Christoph Hellwig <hch@infradead.org>, initramfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
	Dave Jones <davej@redhat.com>, cjwatson@ubuntu.com,
	Bernhard Walle <bwalle@novell.com>
References: <1229540094.28858.150.camel@aglarond.local> <20081217190700.GA15377@infradead.org> <4949FD67.6040906@suse.de> <494B5031.5080306@bfh.ch> <20081219091841.207bc951@kopernikus.site> <494BA7CE.2020007@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494BA7CE.2020007@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 02:55:26PM +0100, Hannes Reinecke wrote:
>
> The goal of the initrd is to activate and mount the root fs.
> And the root fs _only_. Every other system should be configured
> once the main system is running.

Don't forget resuming from hibernation....

And of course, activating and mounting the root filesystem can be
quite complicated --- it can involve loading driver modules,
activiating md and/or lvm, prompting for a password, setting up
networking (dhcp, routing, dns) for iSCSI and/or NFS/AFS/Lustre/et.al,
the equivalent setup for Fiber Channel attached disks, etc.  If
there's any cryptography involved, the user may need to be prompted
for a password and/or key and/or fingerprint scan to unlock TPM unit
to access the key, etc.

There may also be times when it is useful to operate on the root
filesystem in some way before it is mounted; in most cases the
operation can bedone on a filesystem mounted read-only, yes --- but at
the cost of needing to reboot afterwards if the root filesystem needs
to be modified by said userspace tool.

Finally, note that part the discussion at the Kernel Summit, and also
what David Jones was looking to work at, was to do something that
could included as part of the kernel sources.  The idea is that as
responsibility for early boot is moved from the kernel, an mkinitramfs
which is fixed and distributed by the distribution might not work with
a newer kernel.org kernel.  So the idea that was explored was adding a
common mkinitramfs with basic functionality into kernel sources, with
the ability for distributions to add various "value add" enhancements
if they like.  This way if the kernel wants to move more functionality
(for example, in the area of resuming from hibernation) out of the
kernel into initramfs, it can do so without breaking the ability of
older distributions from being able to use kernel.org kernels.

So IMHO, it's important not only that the distributions standardize on
a single initramfs framework, but that framework get integrated into
the kernel sources.

Regards,

						- Ted
