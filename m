Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZLAEup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZLAEup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZLAEun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:50:43 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60868 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbZLAEum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:50:42 -0500
Date: Mon, 30 Nov 2009 23:50:13 -0500
Message-Id: <200912010450.nB14oDPc030851@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 40/41] union-mount: Make truncate work in all its glorious UNIX variations 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:38 PDT."
             <1256152779-10054-41-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-41-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> Implement truncate(), ftruncate(), and open(O_TRUNC) for union mounts.
> 
> This moves the union_copyup() in do_filp_open() down below may_open()
> - this way you don't copy up a file you don't even have permission to
> open.
> 
> may_open() now takes a nameidata * because it may have to do a
> union_copyup() internally if O_TRUNC is specified.  It's a trivial
> change, all callers were just doing "may_open(&nd.path, ...)" anyway.
> It kinda sucks, but may_open() auto-magically doing a truncate also
> sucks (may open? may truncate, too!).

Hmmm, perhaps may_open needs to be renamed then? (may_rename_and_truncate?)

> XXX - Only copy up the bytes that won't be truncated.
> XXX - Re-organize code. may_open() especially blah.
> XXX - truncate() implemented as in-kernel file open and ftruncate()
> XXX - Split up into smaller pieces
[...]

Erez.
