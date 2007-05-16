Return-Path: <linux-kernel-owner+w=401wt.eu-S1762440AbXEPRsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762440AbXEPRsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445AbXEPRsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:48:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283AbXEPRr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:47:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <464B3F2D.9030603@yahoo.com.au>
References: <464B3F2D.9030603@yahoo.com.au> <464B3209.4010003@yahoo.com.au> <464B07EC.4050308@yahoo.com.au> <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com> <17173.1179321391@redhat.com> <19714.1179331928@redhat.com> <23262.1179334587@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 16 May 2007 18:46:48 +0100
Message-ID: <24100.1179337608@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > How do you do a write-through cache for shared-writable mmap?
> 
> For shared writable mmap? I don't know...

You can't do write-through caching for shared-writable mmap because the writes
go directly into the pagecache once the page is made writable, at least, short
of instruction emulation.

At some point in the future we'll be asked to turf the data back to the
server.

> does POSIX require mmap data to be coherent with read(2)/write(2)? ;)

I suspect so, but I don't know offhand.  I want it to be coherent anyway,
otherwise it's inconsistent with OpenAFS and Arla (or at least more so).

Note also that the choice of write-through or write-back caching also has
implications for local on-disk caching of modified data and disconnected
operation.

> I just mean more generally. simple write(2) writes, for starters.

Given that writing through an mmap'd section is write-back by its very
nature[*] and so since I have to do write-back anyway, why consider doing
write-through too?

[*] Unless we want to do instruction emulation or single stepping.

Hmmm... I wonder if O_SYNC should use write-through caching.

David
