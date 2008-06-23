Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbYFWUz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbYFWUz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbYFWUzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:55:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23628 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745AbYFWUzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:55:44 -0400
Date: Mon, 23 Jun 2008 13:38:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andreas Dilger <adilger@sun.com>
Cc: FD Cami <francois.cami@free.fr>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: [PATCH] extX: convert prink(KERN_WARNING) to extX_warning()
Message-Id: <20080623133855.c00ddaa7.randy.dunlap@oracle.com>
In-Reply-To: <20080623203107.GD6239@webber.adilger.int>
References: <20080622201841.669ff882@olorin>
	<20080623203107.GD6239@webber.adilger.int>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 14:31:07 -0600 Andreas Dilger wrote:

> On Jun 22, 2008  20:18 +0200, FD Cami wrote:
> > This patch takes a shot at replacing the direct use of printk(KERN_WARNING)
> > in extX by extX_warning. We now get the device number in the warning message :
> > "EXT3-fs warning (device hda1): ext3_setup_super: maximal mount count reached, running e2fsck is recommended"
> > It also adds the device information on a pair of printk(KERN_ERR) (this was
> > first suggested by Kasper two weeks ago).
> 
> The one issue is that KERN_ERR != KERN_WARNING, so these errors might
> not be visible on the console, or may not be saved to the syslog.  The
> other minor difference is that the function name is also printed, and this
> makes the error message very long.
> 
> One suggestion is to create a separate macro that passes the KERN_*
> flag and __func__ to ext3_console_msg(), and call that from
> ext3_warning() and a new ext3_start_error() function.  I always found
> it annoying to have to specify __func__ as a parameter for every call.
> 
> >  	ext3_warning(sb, __func__,
> > -		     "updating to rev %d because of new feature flag, "
> > -		     "running e2fsck is recommended",
> > -		     EXT3_DYNAMIC_REV);
> > +			"updating to rev %d because of new feature flag, "
> > +			"running e2fsck is recommended",
> > +			EXT3_DYNAMIC_REV);
> 
> Please don't change all of the indenting.  The old indending is proper
> linux coding style (aligned with previous '('), the new one is not.

Hi,
I don't mind which way it's done, but I'm curious:  are you saying that aligning
with '(' is codified (e.g., in CodingStyle) or just that it's dominant?


> Note that you need to split up the patches for ext2, ext3, ext4 into
> separate emails.  I'd suggest just sending one of them until we agree
> on what is right, then submitting the rest afterward.

Thanks,
---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
