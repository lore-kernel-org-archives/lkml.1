Return-Path: <linux-kernel-owner+w=401wt.eu-S965730AbXDCRPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965730AbXDCRPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965752AbXDCRPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:15:55 -0400
Received: from ns2.suse.de ([195.135.220.15]:39548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965730AbXDCRPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:15:54 -0400
To: Ulrich Drepper <drepper@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 03 Apr 2007 20:14:29 +0200
In-Reply-To: <46128051.9000609@redhat.com>
Message-ID: <p73648dz5oa.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper <drepper@redhat.com> writes:

>   to free:      mmap(PROT_NONE) over the area

Why do you need a lock for that? I don't see any problem with
two threads doing that in parallel. The kernel would
serialize it internally and one would fail, but that shouldn't
be a problem. 

Of course having the lock should also not make much difference --
if glibc doesn't do it then it kernel would anyways and run
into the same scalability issue on mmap_sem.

-Andi

