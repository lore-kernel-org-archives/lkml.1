Return-Path: <linux-kernel-owner+w=401wt.eu-S1764933AbZFQHsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764933AbZFQHsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZFQHr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:47:58 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53842 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZFQHr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:47:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Wed, 17 Jun 2009 01:47:11 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 03/17] VFS: Implement handling for pathless pioctls
In-reply-to: <20090616203901.4526.200.stgit@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
       Wang Lei <wang840925@gmail.com>
Message-id: <20090617074711.GZ13073@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
 <20090616203901.4526.200.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 16, 2009  21:39 +0100, David Howells wrote:
> Implement handling for pathless pioctls.  Because these take no path argument,
> there's no way to know for certain which filesystem they're aimed at, so we
> have to switch on command number instead.  This patch allows interested parties
> to register handlers.  Each registered handler function is tried in turn until
> one doesn't return -EOPNOTSUPP.
> 
> This is required because OpenAFS implemented a number of AFS calls that don't
> get given a path as they're aimed at AFS in general, and not at a particular
> file, volume or cell in the AFS world.

Wouldn't it make a lot more sense to create a virtual device, open the
mountpoint, or do _something_ that associates these calls with AFS
directly instead of having the kernel magically route the call to a
specific filesystem?

Not that I agree with having a filesystem-specific syscall either
(sys_reiserfs() was not allowed either :-), but wouldn't even that
be better suited to doing AFS-specific things?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

