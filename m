Return-Path: <linux-kernel-owner+w=401wt.eu-S965237AbXAYDKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965237AbXAYDKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 22:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965236AbXAYDKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 22:10:32 -0500
Received: from pat.uio.no ([129.240.10.15]:56071 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965237AbXAYDKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 22:10:31 -0500
Subject: Re: [discuss] portmapping sucks
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0701250030530.32656@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0701250030530.32656@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 19:10:19 -0800
Message-Id: <1169694619.8355.9.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 198BACBD69FD1AE84BBBAF75324A02ABE395C112
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 10 total 90237 max/h 1952 blacklist 0 greylist 1 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 00:50 +0100, Jan Engelhardt wrote:
> Hello list,
> 
> 
> I just don't know where else I could send this, it's sooo generic to 
> Linux and UNIX (perhaps blame SUN for inventing portmap?)
> Well, here goes...
> 
> As we all know, mountd and other SUNRPC (I question this invention too) 
> services are at a fixed RPC port number (/etc/rpc) which are mapped 
> to a random TCP/UDP port, and the application doing the mappings is
> portmap. This random TCP/UDP port selection is what makes it suck.
> 
> Already twice in 6 months, it has occurred to me that mountd was 
> assigned to vital TCP ports, among which there was:
> 
> 631/tcp causing
>   - cups could not start up properly
>   - samba went into an infinite loop upon startup trying
>     to access port 631 with IPP
> 
> There are a number of common ports in the 512-1023 range. All 
> obsolescence and meaninglessness aside, there _are_ rather "important" 
> services in that range, ldaps, rtsp, kerberos, rsync, ftps, imaps, just 
> to name a few from /etc/services. This map-to-random-port behavior is a 
> total DoS thing.
> 
> Not starting portmap until boot has finished does not work. Think 
> of importing NFS beforehand (/usr, anyone?). Even if, your admin would 
> be very puzzled if he finds that normally-disabled daemons cannot be 
> started at any later time.
> 
> At best I'd obsolete the whole SUNRPC stuff, do away with portmap (and 
> just use TCP/UDP port numbers already) and have a LOT of code simplified 
> (portmap registration for knfsd, to name a prime example).
> Or at least give it fixed TCP/UDP/etc. port numbers too.

1) What the hell does this have to do with the kernel mailing list?

2) Then assign a bloody port number to mountd, and stick to it. Why do
you think there is a '-p' command line option in the first place?

Trond

