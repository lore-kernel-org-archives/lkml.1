Return-Path: <linux-kernel-owner+w=401wt.eu-S1758354AbYABTnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354AbYABTnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYABTnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:43:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbYABTnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:43:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] asm-*/posix_types.h: scrub __GLIBC__
In-Reply-To: Ingo Molnar's message of  Wednesday, 2 January 2008 17:11:08 +0100 <20080102161108.GE21046@elte.hu>
References: <200801021005.33587.vapier@gentoo.org>
	<20080102161108.GE21046@elte.hu>
X-Zippy-Says: Are you mentally here at Pizza Hut??
Message-Id: <20080102194234.8F6EE26F9A0@magilla.localdomain>
Date: Wed,  2 Jan 2008 11:42:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __GLIBC__ uses look like:

	#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)

That block does not affect any extant glibc, so we don't care if you remove
those conditions.  Any non-glibc users of thes headers might care, since
they are the ones affected.

TGhe __USE_ALL uses are all the same one:

	typedef struct {
	#if defined(__KERNEL__) || defined(__USE_ALL)
		int	val[2];
	#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
		int	__val[2];
	#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
	} __kernel_fsid_t;

This might matter in the case of a program compiled in strict ISO C mode,
if some ISO C-standard headers wind up including <asm/posix_types.h>.  
In ISO C it is kosher to write:

	#define val die!die!die!
	#include <stdio.h>

though this is not kosher for POSIX applications.


Thanks,
Roland
