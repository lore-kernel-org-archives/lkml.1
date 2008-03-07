Return-Path: <linux-kernel-owner+w=401wt.eu-S1764884AbYCGT7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764884AbYCGT7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYCGT7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:59:43 -0500
Received: from pat.uio.no ([129.240.10.15]:41596 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYCGT7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:59:42 -0500
Subject: Re: READDIRPLUS max mount option
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Kyle Rose <krose@krose.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
In-Reply-To: <47D1995E.6060501@krose.org>
References: <47D1995E.6060501@krose.org>
Content-Type: text/plain
Date: Fri, 07 Mar 2008 14:59:37 -0500
Message-Id: <1204919978.16746.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: FCF4D5EBB5E690BD5AB7B6C7B17DF302C7104FD6
X-UiO-SR-test: 9727199A816422BD10417A992997EC09BC228DEB
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 415 total 7289692 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-07 at 14:37 -0500, Kyle Rose wrote:
> I have a very specific use for an NFS mount over a WAN, and allowing for 
> much larger expected READDIRPLUS requests actually improves performance 
> by at least a factor of 10 by eliminating the round-trip latency that 
> results from the application's single-threaded 
> readdir/stat/stat/stat/... behavior.  Rather than maintain a hacked 
> kernel on my end, I'd rather the READDIRPLUS limit be a mount option.  
> Hence, the following patch.  It defaults to the old behavior 
> (8*PAGE_SIZE), but with a properly-prepared mount binary will allow the 
> client to specify a limit.
> 
> I'm not subscribed to the list, so please CC me in any relevant discussion.
> 
> Kyle

(adding cc to linux-nfs@vger.kernel.org)

The binary mount format is frozen forever, so the changes to nfs_mount.h
and nfs4_mount.h are definitely NACKed.

Otherwise, it would be nice to know why this absolutely has to be made a
mount option rather than just having a system-wide option (either a
module/boot parameter or a sysctl) to control the behaviour of all
mounts.

Cheers
  Trond

