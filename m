Return-Path: <linux-kernel-owner+w=401wt.eu-S964865AbXAXXuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865AbXAXXuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 18:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXAXXuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 18:50:22 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:39331 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbXAXXuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 18:50:21 -0500
Date: Thu, 25 Jan 2007 00:50:16 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [discuss] portmapping sucks
Message-ID: <Pine.LNX.4.61.0701250030530.32656@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,


I just don't know where else I could send this, it's sooo generic to 
Linux and UNIX (perhaps blame SUN for inventing portmap?)
Well, here goes...

As we all know, mountd and other SUNRPC (I question this invention too) 
services are at a fixed RPC port number (/etc/rpc) which are mapped 
to a random TCP/UDP port, and the application doing the mappings is
portmap. This random TCP/UDP port selection is what makes it suck.

Already twice in 6 months, it has occurred to me that mountd was 
assigned to vital TCP ports, among which there was:

631/tcp causing
  - cups could not start up properly
  - samba went into an infinite loop upon startup trying
    to access port 631 with IPP

There are a number of common ports in the 512-1023 range. All 
obsolescence and meaninglessness aside, there _are_ rather "important" 
services in that range, ldaps, rtsp, kerberos, rsync, ftps, imaps, just 
to name a few from /etc/services. This map-to-random-port behavior is a 
total DoS thing.

Not starting portmap until boot has finished does not work. Think 
of importing NFS beforehand (/usr, anyone?). Even if, your admin would 
be very puzzled if he finds that normally-disabled daemons cannot be 
started at any later time.

At best I'd obsolete the whole SUNRPC stuff, do away with portmap (and 
just use TCP/UDP port numbers already) and have a LOT of code simplified 
(portmap registration for knfsd, to name a prime example).
Or at least give it fixed TCP/UDP/etc. port numbers too.

Request for discussion.


Thanks,
Jan
-- 
