Return-Path: <linux-kernel-owner+w=401wt.eu-S934426AbXGZQ6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426AbXGZQ6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761832AbXGZQ61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:58:27 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:36323 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764360AbXGZQ60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:58:26 -0400
Date: Thu, 26 Jul 2007 17:57:36 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] ELF core dump options
In-Reply-To: <20070726113924.6017C4D058D@magilla.localdomain>
Message-ID: <Pine.LNX.4.64.0707261753030.370@blonde.wat.veritas.com>
References: <20070726113924.6017C4D058D@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAcm9sYW5kQHJlZGhhdC5jb20AYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwB0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZwBoaWRlaGlyby5rYXdhaS5lekBoaXRhY2hpLmNvbQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Roland McGrath wrote:
> 
> > hm, I'm now wondering whether testing i_nlink was the best (or official)
> > way of determining whether a MAP_SHARED vma is anonymous or file-backed.
> > Hugh will know.
> 
> Well, it doesn't exactly test that it's not "file-backed".  (Technically
> anything shared is file-backed, even if by a shmem virtual file.)  It tests
> whether the backing file will probably ever be found on disk later.  That
> gets shmem regions as well as originally-regular files that were deleted
> while mapped.  I think we asked around when this test was put it and it was
> deemed proper at the time.  (It doesn't really need to be a formal "what
> does the vm situation mean" guarantee, just a practical "you probably
> wanted that" test.)

Exactly, a rough heuristic which seemed to approximate what the coredump
people wanted when it went into 2.6.12.  No absolute justification to it.

Hugh
