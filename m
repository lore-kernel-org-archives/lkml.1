Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXCGPxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXCGPxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXCGPxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:53:33 -0500
Received: from raven.upol.cz ([158.194.120.4]:40560 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbXCGPxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:53:32 -0500
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, akpm@linux-foundation.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       johannes@sipsolutions.net
Subject: ALIGN via ilog2 without gccisms (Re: [PATCH] Fix get_order())
In-Reply-To: <8543.1173267786@redhat.com>
References: <Pine.LNX.4.64.0703061913080.5963@woody.linux-foundation.org> <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com> <8543.1173267786@redhat.com>
Date: Wed, 7 Mar 2007 17:02:53 +0100
Message-Id: <E1HOybN-00031m-6M@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Howells
> Newsgroups: gmane.linux.kernel
> Subject: Re: [PATCH] Fix get_order()
> Date: Wed, 07 Mar 2007 11:43:06 +0000
>
[]
> Various archs (including i386, x86_64, powerpc and frv) have instructions that
> can be used to calculate integer log2(N).
>
Probably it can be used to get rid of gccisms and "type fluff" due to
bitwise arithmetics in ALIGN?
Here:

#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))

like that:

#define ALIGN(x,y)		__ALIGN_MASK(x,ilog2(y))
#define __ALIGN_MASK(x,bits)	(((((x) >> (bits)) << 1) + 2) << (bits - 1))

Note side effect, that this one always yields even result. Maybe this is
good, due to avoidance of misaligned access.

____
