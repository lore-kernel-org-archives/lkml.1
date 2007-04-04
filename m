Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbXDDOhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbXDDOhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbXDDOhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:37:24 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:15093 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbXDDOhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:37:23 -0400
X-AuditID: d80ac287-91f24bb000000c42-1a-4613b8222e74 
Date: Wed, 4 Apr 2007 15:37:17 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Marko Macek <Marko.Macek@gmx.net>
cc: Ulrich Drepper <drepper@redhat.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: missing madvise functionality
In-Reply-To: <4613131A.2060206@gmx.net>
Message-ID: <Pine.LNX.4.64.0704041524080.15525@blonde.wat.veritas.com>
References: <46128051.9000609@redhat.com> <4613131A.2060206@gmx.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 04 Apr 2007 14:37:22.0158 (UTC) FILETIME=[C14698E0:01C776C6]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Marko Macek wrote:
> Ulrich Drepper wrote:
> > A solution for this problem is a madvise() operation with the following
> > property:
> > 
> >   - the content of the address range can be discarded
> > 
> >   - if an access to a page in the range happens in the future it must
> >     succeed.  The old page content can be provided or a new, empty page
> >     can be provided
> 
> Doesn't this conflict with disabling overcommit?
> 
> If the page is guaranteed to be available, obviously it must count as
> being commited, so this is not equivalent to real freeing.

No, there's no conflict with disabled overcommit here: Committed_AS
accounting is done on the whole vma size (at mmap or brk time), no
matter how many pages may or may not be faulted in later.  Rather
like RLIMIT_AS.  The proposed madvise operation won't affect it.

(But I take Ulrich's "must succeed" with one pinch of salt:
Out-Of-Memory killing remains a possibility, of course.)

Hugh
