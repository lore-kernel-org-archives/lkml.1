Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbXF3Uwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbXF3Uwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 16:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXF3UwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 16:52:22 -0400
Received: from kallisti.us ([67.59.168.233]:44992 "EHLO kallisti.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbXF3UwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 16:52:21 -0400
X-Greylist: delayed 1432 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jun 2007 16:52:21 EDT
From: Ross Vandegrift <ross@kallisti.us>
Date: Sat, 30 Jun 2007 16:28:21 -0400
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com
Subject: dump of ext3 very slow from dm LV
Message-ID: <20070630202821.GA2770@kallisti.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

A while back I asked about this on the LVM mailing list, but didn't
receive a response.  Am revisiting it now, so would like a broader
audience.

I've run into some substantial read slowness when using dump or tar
to backup filesystems that are stored on LVM2 LVs.  All of my tests
are dumping ext3 filesystems to /dev/null.

I'm seeing speeds in the range of 3-4MiB/s.  If I increase dump's
blocksize to 128KiB records, speed jumps up to about 20KiB/s, which
is better but still frustratingly slow. Going to 1024KiB gets me
about 28MiB/s.

Today I loop mounted a file on my LVM, filled it up with some crap
from urandom and dumped it out.  I was able to get 50-60MiB/s.  

Is this amount of performance loss due to dm expected? My LV is just two
SATA hard disks that I put into a VG. Stupid benchmarks with dd gives me
a raw read speed from the LV of about 60MiB/sec.

I'm using kernel 2.6.18-4-686 from debian.  Any ideas on what's
slowing down dump? 
-- 
Ross Vandegrift
ross@kallisti.us

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
