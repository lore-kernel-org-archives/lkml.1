Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757338AbYLQAwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbYLQAwY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYLQAwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:52:15 -0500
Received: from eazy.amigager.de ([213.239.192.238]:45875 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYLQAwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:52:14 -0500
Date: Wed, 17 Dec 2008 01:52:10 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Very slow header cache in mutt if the maildir is on ext3
Message-ID: <20081217005210.GA889@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20081217001625.GA3250@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217001625.GA3250@x61>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 01:16:25 +0100, Tino Keitel wrote:

[...]

> The strange thing is that in both cases (maildir on ext3 and maildir on
> XFS), the header cache file is stored on a separate file system on a
> different hard disk on an XFS file system.  I don't get the point why
> reading the header cache from this XFS file system is so slow when the
> maildir is on ext3, and fast when the maildir is on XFS.
> 
> Here are strace excerpts for XFS and ext3, taken with "strace -f -s0
> -tt" after doing "echo 7 > /proc/sys/vm/drop_caches":
> 
> http://tikei.de/mutt_hcache_xfs.txt
> http://tikei.de/mutt_hcache_ext3.txt

OK, after glancing at the strace output again, I see that the seek
offsets are much more linear in the XFS case, whereas they are pretty
random in the ext3 case.  I guess that this is connected to the order
of the files in the maildir, which depends on the FS type.  So this is
a bug in mutt which makes reading the header cache dead slow if the
files are in an inconvenient order.

Thanks to Goswin Brederlo for hinting at the seek offsets.

Regards,
Tino
