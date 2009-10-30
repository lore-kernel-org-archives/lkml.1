Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbZJ3LOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbZJ3LOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 07:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756995AbZJ3LOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 07:14:49 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48708 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950AbZJ3LOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 07:14:48 -0400
Date: Fri, 30 Oct 2009 05:14:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Tejun Heo <teheo@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] Sysfs: Allow directories to be populated
	dynamically
Message-ID: <20091030111452.GP10555@parisc-linux.org>
References: <20091020054740.GC29158@parisc-linux.org> <20091020055021.GE29158@parisc-linux.org> <4AE9C0B0.3030304@suse.de> <20091029162145.GM10555@parisc-linux.org> <4AE9C29E.6090706@suse.de> <20091029192414.GN10555@parisc-linux.org> <4AEABD32.8010509@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEABD32.8010509@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 11:17:22AM +0100, Tejun Heo wrote:
> Matthew Wilcox wrote:
> > It is convoluted.  The advantage of this is that we get to create many
> > fewer dirents.  I wonder if we can do away with the dirents entirely, and
> > have dentries constructed dynamically instead.
> 
> I think it's a bit misdirected.  It's probably better to try to reduce
> the size of struct sysfs_dirent by tightly packing them and moving out
> dynamic part of the data structure into a separate one which is only
> allocated while the node is being accessed.  The thing is that large
> number of the nodes would require struct sysfs_dirent anyway, so it
> would be much more benficial and less convoluted to diet the whole
> thing.
> 
> In this particular case, the trade off is actually much worse because
> sysfs_dirent is being increased but the only one which is seeing any
> kind of memory usage drop is the new msi-x code.  Given that there can
> be only a handful of msi-x controllers even in a fairly large system,
> I don't think memory usage will be reduced in any meaningful way even
> on affected systems and if you think about large systems with
> thousands and tens of thousands block devices, the bloat in
> sysfs_dirent will waste a lot of memory.

Every attribute sees a drop in memory usage.  I think I saw about 30%
fewer dirents created on boot with this laptop.  Why not try this patch
on one of your machines and see the difference?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
