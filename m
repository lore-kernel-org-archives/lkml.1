Return-Path: <linux-kernel-owner+w=401wt.eu-S965104AbXC3LYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104AbXC3LYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 07:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965085AbXC3LYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 07:24:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965104AbXC3LYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 07:24:33 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <6d6a94c50703300334w6b4787f3p144715de5166d7bc@mail.gmail.com> 
References: <6d6a94c50703300334w6b4787f3p144715de5166d7bc@mail.gmail.com>  <1175226172.15391.66.camel@roc-desktop> <10785.1175247540@redhat.com> 
To: "Aubrey Li" <aubreylee@gmail.com>
Cc: vapier.adi@gmail.com, jie.zhang@analog.com, bryan.wu@analog.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu arch dont zero the anonymous mapping by adding UNINITIALIZE flag 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 30 Mar 2007 12:24:22 +0100
Message-ID: <15938.1175253862@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aubrey Li <aubreylee@gmail.com> wrote:

> malloc() allocates size bytes and returns a pointer to the allocated memory.
> ****The memory is not cleared.****

But this is *not* malloc().  It's mmap().  Are you prepared to guarantee that
there are no applications out there that don't rely on anon mmap() giving
zeroed memory?

The MMU-mode clearing is done for security reasons - there shouldn't be any
leakage between processes, and because the zero page can just be faulted in.

Personally, I'd prefer to maintain compatibility with MMU-mode wherever
possible, but I'm happy with overrides like the MAP_UNINITIALISED flag
suggested.

David
