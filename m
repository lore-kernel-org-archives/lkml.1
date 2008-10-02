Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYJBWrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYJBWrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYJBWrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:47:12 -0400
Received: from waste.org ([66.93.16.53]:37407 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbYJBWrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:47:10 -0400
Subject: Re: [PATCH] mm: unify shmem and tiny-shmem
From: Matt Mackall <mpm@selenic.com>
To: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1710.1222986220@redhat.com>
References: <Pine.LNX.4.64.0810011817060.19654@blonde.site>
	 <1222818570.13453.5.camel@calx>  <1710.1222986220@redhat.com>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 17:44:02 -0500
Message-Id: <1222987442.13453.89.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-10-02 at 23:23 +0100, David Howells wrote:
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > That's much nicer than I'd been imagining, thanks Matt: I've no qualms
> > about the few #ifdefs you're adding to mm/shmem.c, it does seem an
> > outright improvement that you're bringing them together.
> 
> It's not an outright improvement.  shmem.o is still larger than tiny-shmem.o,
> albeit not a lot; however, some embedded people really do count the bytes.

Here the difference comes down to 16 bytes for the "if (size < 0)"
check/branch, which is a worthwhile check.

> > This ifndef is the ugliest part of it: and looking into it, guess
> > what, shmem_get_unmapped_area() hasn't been used since 2.6.20 -
> > that's right, isn't it, David?
> 
> Ummm...  It seems to be.  I think it used to be used by SYSV SHM.  Certainly
> deleting that function causes no link problems.

I've got a patch queued to drop it, will post shortly.

-- 
Mathematics is the supreme nostalgia of our time.

