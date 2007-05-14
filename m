Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbXENUrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbXENUrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbXENUq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:46:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807AbXENUq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:46:56 -0400
Date: Mon, 14 May 2007 16:46:52 -0400
From: Dave Jones <davej@redhat.com>
To: Rob Landley <rob@landley.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: tracking down disk spinups.
Message-ID: <20070514204651.GA7242@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rob Landley <rob@landley.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070514185734.GM27604@redhat.com> <200705141628.35617.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705141628.35617.rob@landley.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 04:28:35PM -0400, Rob Landley wrote:
 > On Monday 14 May 2007 2:57 pm, Dave Jones wrote:
 > > Why did the kernel ignore what I told it to do ?
 > > I'm sure it thinks it knows better than me for a reason, but
 > > I'd like to know what it is.
 > 
 > Remount doesn't switch filesystem drivers, it tells the existing filesystem 
 > driver to accept new flags and/or a new option string.

yes, I had misinterpreted what 'remount' did. I thought behind the scenes
it actually did a umount/mount.

 > To switch drivers you have to umount the old sucker and mount the new one.  
 > (The idea of handing off consistent cache data from one mounted filesystem 
 > driver to another...  Ouch.)

a umount would purge the cache, but that's irrelevant given it doesn't
work that way.

Anyways, I rebooted after s/ext3/ext2/ on my fstab, and found things
hadn't really got any more obvious what was going on.
Instead of 'kjournald' writing stuff out, now it's 'pdflush'.

*has sudden brainwave*

Ahh, it's doing atime updates. Duh.

	Dave

-- 
http://www.codemonkey.org.uk
