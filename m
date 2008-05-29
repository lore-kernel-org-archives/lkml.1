Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYE2NQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYE2NQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYE2NPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:15:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYE2NPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:15:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0805281328310.982@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805281328310.982@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0805281646470.27125@sbz-30.cs.Helsinki.FI> <20080528153648.GA27783@linux-sh.org> <483DBA85.2060502@cs.helsinki.fi> <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com> <483DBFC3.1070108@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
Cc: dhowells@redhat.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
       cooloney@kernel.org, akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 29 May 2008 14:08:37 +0100
Message-ID: <29611.1212066517@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Lameter <clameter@sgi.com> wrote:

> Could the nommu people either tell us what this is all about? Or junk the 
> code. This looks very wrong.

ELF-FDPIC is currently using kobjsize() so that it can expand the heap/stack
segment to fill up the entirety of its allocation.  It's probably worth
dropping that, though.

NOMMU mmap() is using kobjsize()/ksize() to keep track of the number of bytes
allocated and the amount of dead space.  We can probably ditch that too.

However, fs/proc/task_nommu.c uses kobjsize() quite a bit to determine how
much metadata space a process is carrying around.  We could just use sizeof(),
I suppose, and not bother calculating the slack.

David
