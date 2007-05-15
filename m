Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbXEOVoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbXEOVoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbXEOVoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:44:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755466AbXEOVoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:44:11 -0400
Date: Tue, 15 May 2007 14:40:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 2/2] AFS: Implement shared-writable mmap
Message-Id: <20070515144007.f87d9be5.akpm@linux-foundation.org>
In-Reply-To: <20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com>
References: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com>
	<20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 16:52:31 +0100
David Howells <dhowells@redhat.com> wrote:

> Implement shared-writable mmap for AFS.

This blows up in -mm:

fs/afs/file.c:59: error: 'filemap_nopage' undeclared here (not in a function)
fs/afs/file.c:60: error: unknown field 'populate' specified in initializer
fs/afs/file.c:60: error: 'filemap_populate' undeclared here (not in a function)

because Nick went and renamed half the VM and deleted the other half.

I need to work out what to do with

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-merge-nopfn-into-fault.patch
convert-hugetlbfs-to-use-vm_ops-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch

Probably merge them, I guess.  Hugh had concerns, I think over small
additional overhead from the lock_page()?

