Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbXHBSx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbXHBSx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759991AbXHBSxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:53:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54426 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758609AbXHBSxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:53:03 -0400
Date: Thu, 2 Aug 2007 11:52:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Guillaume Chazarain" <guichaz@yahoo.fr>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Petr Tesarik" <ptesarik@suse.cz>,
       "Dave Chinner" <dgc@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Andrea Arcangeli <andrea@novell.com>
Subject: Re: mmap behavior on out-of-space conditions
Message-Id: <20070802115243.610c4e61.akpm@linux-foundation.org>
In-Reply-To: <3d8471ca0708020618g5b7cf05dr350c25626137a13e@mail.gmail.com>
References: <1186058486.2289.17.camel@elijah.suse.cz>
	<1186059975.12034.111.camel@twins>
	<3d8471ca0708020618g5b7cf05dr350c25626137a13e@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007 15:18:33 +0200
"Guillaume Chazarain" <guichaz@yahoo.fr> wrote:

> 2007/8/2, Peter Zijlstra <peterz@infradead.org>:
> 
> > I think Dave's block_page_mkwrite() stuff addresses this as well, no?
> >
> > http://lkml.org/lkml/2007/3/18/198
> 
> I saw a similar problem some time ago with msync:
> http://lkml.org/lkml/2006/12/29/136 but Andrew didn't
> like my patch.
> 

Yeah, we need to get that finished off.

The current _design_ of the VM/VFS is such that if the application runs
fsync() or msync() then it will be able to reliably detect any data loss
which has occurred, even if that data loss occurred during a random pageout
attempt by some other process half an hour ago.

However Guillaume has identified some holes in the implementation (I don't
recall the details, but that link is a start).

