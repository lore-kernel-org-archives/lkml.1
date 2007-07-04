Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbXGDID3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbXGDID3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbXGDIDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:03:10 -0400
Received: from ozlabs.org ([203.10.76.45]:45449 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbXGDIDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:03:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18059.21555.317415.928416@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 18:02:59 +1000
From: Paul Mackerras <paulus@samba.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oliver@neukum.org, benh@kernel.crashing.org, mjg59@srcf.ucam.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM
	pathway
In-Reply-To: <E1I5ysv-0005xf-00@dorka.pomaz.szeredi.hu>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707031307.41366.oliver@neukum.org>
	<1183463053.10386.112.camel@localhost.localdomain>
	<200707031355.51028.oliver@neukum.org>
	<18058.56956.595143.15424@cargo.ozlabs.ibm.com>
	<E1I5ysv-0005xf-00@dorka.pomaz.szeredi.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi writes:

> That's weird, I never had a suspend problem due to a fuse mount,
> though I have them all the time.  And I suspect, that even the sync()

Well, I don't either, because we don't freeze processes on
powerbooks.  But I have heard that other people have problems with
suspending with a fuse filesystem mounted.  Maybe the difference is
whether or not the filesystem is writable?

> thing that suspend does is not the real cause, because sync() actually
> does nothing in fuse filesystems.

It's not the filesystem sync method, as I understand it, it's that if
there are dirty pages in the page cache for files on the fuse
filesystem, the system will initiate a write-out on them and wait for
it to finish.  But if the fuse userspace is frozen, the write-out will
never complete.

Paul.
