Return-Path: <linux-kernel-owner+w=401wt.eu-S1761380AbXHNOSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380AbXHNOSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 10:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbXHNOSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 10:18:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbXHNOSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 10:18:10 -0400
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@osdl.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [autofs] [PATCH] autofs4: deadlock during create
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
References: <1187087280.4963.18.camel@raven.themaw.net>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Tue, 14 Aug 2007 10:17:45 -0400
In-Reply-To: <1187087280.4963.18.camel@raven.themaw.net> (Ian Kent's message of "Tue\, 14 Aug 2007 18\:28\:00 +0800")
Message-ID: <x49mywuci9i.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> Hi,
>
> Due to inconsistent locking in the VFS between calls to lookup and
> revalidate deadlock can occur in the automounter.
>
> The inconsistency is that the directory inode mutex is held for both
> lookup and revalidate calls when called via lookup_hash whereas it is
> held only for lookup during a path walk. Consequently, if the mutex
> is held during a call to revalidate autofs4 can't release the mutex
> to callback the daemon as it can't know whether it owns the mutex.
>
> This situation happens when a process tries to create a directory
> within an automount and a second process also tries to create the
> same directory between the lookup and the mkdir. Since the first
> process has dropped the mutex for the daemon callback, the second
> process takes it during revalidate leading to deadlock between the
> autofs daemon and the second process when the daemon tries to create
> the mount point directory.
>
> After spending quite a bit of time trying to resolve this on more than
> one occassion, using rather complex and ulgy approaches, it turns out
> that just delaying the hashing of the dentry until the create operation
> work fine.
>
> Signed-off-by: Ian Kent <raven@themaw.net>

Acked-by: Jeff Moyer <jmoyer@redhat.com>

-Jeff
