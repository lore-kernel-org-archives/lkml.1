Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbXKUOCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbXKUOCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 09:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbXKUOCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 09:02:06 -0500
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:35091 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477AbXKUOCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 09:02:05 -0500
Message-ID: <47443A83.2020607@lougher.demon.co.uk>
Date: Wed, 21 Nov 2007 14:02:43 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       maximilian attems <max@stro.at>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANN] Squashfs 3.3 released
References: <472EFACA.1090308@lougher.demon.co.uk> <20071105115624.GJ14432@baikonur.stro.at> <4731E880.6010303@lougher.demon.co.uk> <20071120235048.GA15764@redhat.com>
In-Reply-To: <20071120235048.GA15764@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:

> 
> The biggest problem we've seen with it (asides from having to rediff
> it every time we rebase when there isn't a newer upstream)

Yes, this is mainly my fault.  There was a gap of 10 months between the 
3.2 release in January this year, and the latest in November. With the 
rate of new kernel releases this wasn't really acceptable because the 
January release was stuck with a patch for kernels no newer than 2.6.20. 
I received numerous complaints about it.

Some of you may be aware that I started work at Canonical, and this left 
almost no spare-time to work on Squashfs for 9 months.

>is complaints
> along the lines of "my Fedora 7 kernel can't unpack squashfs images
> from Fedora 5"
> (s/Fedora 5/other random older distros/ )
>

Squashfs has backwards compatibility with older versions, and it should 
mount all older versions back to 2.0 (released May 2004). Unfortunately 
RedHat grabbed a CVS version of Squashfs just before the 3.0 release. 
This was development code, and release testing showed it
had a bug where it couldn't mount older versions. It was fixed for
release.

> If the format is now stable however, it would be great to get it upstream.
> 

The move from the 2.0 format to the later 3.0 format was mainly forced 
by the demands of the Linux kernel mailing list when I first submitted 
it early 2005.  There was no other way to incorporate demands for larger 
than 4GB filesystems, and provide support for "." and ".." in readdir 
without modifying the filesystem format.

Unfortunately the move to fixed little endian filesystem will involve 
another filesystem layout change.  The current filesystem layout still 
uses packed bitfield structures, and it is impossible to swap these 
using the standard kernel swap macros.  Removal of my routines that can 
properly swap packed bitfield structures is another change demanded by 
the Linux kernel mailing list.

Once the little endian work has been done, and hopefully once it is in 
the kernel, I don't anticipate any further layout changes.

Phillip

