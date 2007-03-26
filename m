Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbXCZNZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbXCZNZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 09:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXCZNZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 09:25:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXCZNZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 09:25:10 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703261525370.14158@sbz-30.cs.Helsinki.FI> 
References: <Pine.LNX.4.64.0703261525370.14158@sbz-30.cs.Helsinki.FI>  <Pine.LNX.4.64.0703261447190.13229@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0703261427490.12793@sbz-30.cs.Helsinki.FI> <20070326024143.a226c9b2.akpm@linux-foundation.org> <1174904637.32691.86.camel@roc-desktop> <6017.1174908318@redhat.com> <6791.1174909459@redhat.com> <11045.1174911764@redhat.com> 
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error bug 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 26 Mar 2007 14:24:38 +0100
Message-ID: <22674.1174915478@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> We don't touch private mappings at all as they're a snapshot to the inode 
> _before_ it was revoked. So private mappings don't really matter all: you 
> don't see any new data after it has been revoked nor do you flush anything 
> to the disk.

Okay, so that's not a problem.

> Well, assuming we would use revoke for things like SAK, this doesn't 
> really work out too well because all a malicious process has to is create 
> a shared mapping and they've effectively blocked the whole thing.

In NOMMU-mode, there's probably[*] nothing stopping a malicious process
running completely amok and changing stuff directly - even the kernel isn't
guaranteed to be safe - so I wouldn't worry about such a case.

[*] The FRV, for example, does have some limited protection capability - but
it is really limited and not really useful in this case.

> It's antisocial for sure but the only way to guarantee revoke() succeeds on
> a NOMMU setup.  Oh well, lets disable it for now and see if anyone even
> wants revoke() for NOMMU.

Agreed.

David
