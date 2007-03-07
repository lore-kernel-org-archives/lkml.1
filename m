Return-Path: <linux-kernel-owner+w=401wt.eu-S965699AbXCGWRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965699AbXCGWRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965698AbXCGWRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:17:24 -0500
Received: from ozlabs.org ([203.10.76.45]:41789 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992661AbXCGWRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:17:19 -0500
Date: Wed, 7 Mar 2007 16:14:02 -0600
From: Anton Blanchard <anton@samba.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
Message-ID: <20070307221401.GA16938@kryten>
References: <45ED1A3C.6030707@argo.co.il> <200703071906.58405.dada1@cosmosbay.com> <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org> <200703071952.13219.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703071952.13219.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Well, I hope a prefetch(NULL) is OK because we are doing millions of
> them (see include/linux/list.h :) )

Funny you mention this. We found some noticeable ppc64 regressions when
moving the dcache to standard list macros and had to do this to fix it
up:

static inline void prefetch(const void *x)
{
        if (unlikely(!x))
                return;

        __asm__ __volatile__ ("dcbt 0,%0" : : "r" (x));
}

Urgh :)

Anton
