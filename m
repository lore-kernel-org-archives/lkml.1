Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbZFSK7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbZFSK7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 06:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZFSK7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 06:59:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33672 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbZFSK7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 06:59:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1245371813-30954-1-git-send-email-vapier@gentoo.org>
References: <1245371813-30954-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rmap: fixup page_referenced() for nommu systems
Date: Fri, 19 Jun 2009 11:58:32 +0100
Message-ID: <22599.1245409112@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> After the recent changes that went into mm/vmscan.c to overhaul stuff, we
> ended up with these warnings on no-mmu systems:
> mm/vmscan.c: In function 'shrink_page_list':
> mm/vmscan.c:580: warning: unused variable 'vm_flags'
> mm/vmscan.c: In function 'shrink_active_list':
> mm/vmscan.c:1294: warning: 'vm_flags' may be used uninitialized in this function
> mm/vmscan.c:1242: note: 'vm_flags' was declared here
> 
> This is because the no-mmu function defines page_referenced() to work on
> the first argument only (the page).  It does not clear the vm_flags given
> to it because for no-mmu systems, they never actually get utilized.  Since
> that is no longer strictly true, we need to set vm_flags to 0 like everyone
> else so gcc can do proper dead code elimination without annoying us with
> unused warnings.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: David Howells <dhowells@redhat.com>
