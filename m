Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYFVQaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYFVQaP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 12:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYFVQ36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 12:29:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754414AbYFVQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 12:29:38 -0400
Date: Sun, 22 Jun 2008 09:29:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: ecollins@vmware.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       support@vmware.com
Subject: Re: Linux 2.6.26-rc7
In-Reply-To: <b6a2187b0806220012t118d85ffp671abf715c14ea94@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0806220926150.2926@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0806201626140.3167@woody.linux-foundation.org> <b6a2187b0806220012t118d85ffp671abf715c14ea94@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Jun 2008, Jeff Chua wrote:

> On Sat, Jun 21, 2008 at 7:42 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Another week, another -rc.
> > Linus Torvalds (4):
> >      Reinstate ZERO_PAGE optimization in 'get_user_pages()' and fix XIP
> 
> [89f5b7da2a6bad2e84670422ab8192382a5aeb9f]
> 
> This broke vmware 6.0.4.

Hmm. Can you see which part of it broke? Was it the "fix XIP" part ot the 
ZERO_PAGE part? The easiest way to test is to apply this patch, and see 
(it just disables the XIP part of fix)

		Linus
---
 mm/memory.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9aefaae..9056132 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1023,8 +1023,12 @@ out:
 	return page;
 
 bad_page:
+#if 0
 	pte_unmap_unlock(ptep, ptl);
 	return ERR_PTR(-EFAULT);
+#else
+	return NULL;
+#endif
 
 no_page:
 	pte_unmap_unlock(ptep, ptl);
