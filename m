Return-Path: <linux-kernel-owner+w=401wt.eu-S1765046AbYBUAOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765046AbYBUAOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYBUAOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:14:31 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:51536 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYBUAO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:14:29 -0500
Date: Thu, 21 Feb 2008 00:13:58 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Jesse Barnes <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Message-ID: <20080221001357.GA29796@srcf.ucam.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201241.30952.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org> <200802201344.11643.jesse.barnes@intel.com> <47BCAD6E.9080704@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BCAD6E.9080704@nigel.suspend2.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 09:45:02AM +1100, Nigel Cunningham wrote:

> - people keep talking about hibernating to an ext3 fs mounted on fuse as 
> a limitation of the freezer. To do that with kexec, you're still going 
> to have to bmap the ext3 fs and pass the block list (in which case we 
> can also do it without kexec) or umount all the ext3/fuse part and 
> remount in the kexec'd kernel. Sort of defeats the purpose, doesn't it?

No, with a freezer-based model you can basically *never* suspend to 
anything related to FUSE or a userspace USB device or anything involving 
userspace iSCSI initiators or whatever. Sure, there are cases where 
moving away from the current model doesn't buy you anything, but that 
doesn't mean that the current model is a good thing. It's not. The 
freezer is a fundamentally broken concept.

> I also wonder about how much of a pain it's going to be setting up 
> userspace for this kexec'd kernel. Will you need a separate partition 
> just for it? If not, will the userspace be loaded into memory all the 
> time (more memory wasted for normal use), or loaded from ordinary 
> partitions at kexec time (how to do safely? - more info to transfer 
> between kernels?).

You're looking at a tiny amount of memory when compared to current 
systems. It's really not a problem.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
