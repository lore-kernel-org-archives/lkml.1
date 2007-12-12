Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbXLLWan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbXLLWan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbXLLWa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:30:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53803 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbXLLWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:30:26 -0500
Date: Wed, 12 Dec 2007 14:18:22 -0800
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       clameter@sgi.com
Subject: Re: [PATCH -mm] x86 boot : export boot_params via sysfs (forward
	to Greg)
Message-ID: <20071212221822.GB16474@kroah.com>
References: <1197443265.14443.59.camel@caritas-dev.intel.com> <20071212073502.GA31348@kroah.com> <1197447079.14443.82.camel@caritas-dev.intel.com> <20071212174507.GB16049@kroah.com> <20071212191535.GB31044@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212191535.GB31044@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 02:15:35PM -0500, Dave Jones wrote:
> On Wed, Dec 12, 2007 at 09:45:07AM -0800, Greg Kroah-Hartman wrote:
> 
>  > Well, I respectively disagree.  sysfs is NOT for exporting various
>  > binary kernel structures to userspace directly.  Again, the binary files
>  > in sysfs are for chunks of memory that are PASS-THROUGH from hardware to
>  > userspace, with no kernel intervention at all.
>  > If you really need such a thing, use debugfs, as the only rule for
>  > debugfs is that there is no rules :)
> 
> Whilst on the subject, why wasn't /sys/slab done in debugfs ?
> The one-value-per-file thing has gone taken to ridiculous extremes there.

Heh, I think most of those files only show up if you have
CONFIG_SLUB_DEBUG enabled, and it's easier to add them to the original
sysfs entries instead of creating new debugfs ones.

> Having 3641 sysfs files that most people never use permanently taking up
> memory seems to be a massive waste of resources.

sysfs files have their dentries and inodes pushed out of memory if they
are never accessed, so no huge ammounts of memory are used here.

Otherwise we would never be able to support 20,000 block devices on a
31bit s390 with 128Mb of ram :)

thanks,

greg k-h
