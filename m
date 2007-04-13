Return-Path: <linux-kernel-owner+w=401wt.eu-S965646AbXDMXBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965646AbXDMXBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965679AbXDMXBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:01:46 -0400
Received: from crown.reflexsecurity.com ([72.54.139.163]:46387 "EHLO
	crown.reflexsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965646AbXDMXBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:01:45 -0400
X-Reflex-Keepalives: .
Date: Fri, 13 Apr 2007 19:01:39 -0400
From: Jason Lunz <lunz@falooley.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cameron Schaus <cam@schaus.ca>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 OOM with 8Gb RAM
Message-ID: <20070413230139.GB6783@metaxa.reflex>
References: <20070412173830.GA31323@schaus.ca> <20070412121553.c7fd3249.akpm@linux-foundation.org> <20070413223935.GA6783@metaxa.reflex> <20070413154653.21fdb914.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413154653.21fdb914.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 03:46:53PM -0700, Andrew Morton wrote:
> > If I want to run a system entirely from ram with a compressed filesystem
> > image mounted on /, is it better to store that image in a ramdisk, or on
> > a tmpfs and mount it via loopback?
> 
> Store it all in ramfs, no loopback needed?

I used to put everything in a tmpfs on /, and that certainly works. But
most files in a typical image are rarely used and it's a pity to have
lots of little files taking up a 4k page each.

You get pretty big savings by compressing the system into a squashfs and
mounting that, so the question becomes: where to put the squashfs?
ramdisk or loopback mount it from tmpfs/ramfs?

iirc, the problems with loopback have to do with writeout, which isn't a
problem here since squashfs is readonly.

Jason
