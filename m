Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbZL3SCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbZL3SCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZL3SCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:02:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46844 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZL3SCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:02:43 -0500
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [RFC][PATCH 2/2] readahead: avoid page-by-page reads on POSIX_FADV_RANDOM
From: Andi Kleen <andi@firstfloor.org>
References: <20091225000717.GA26949@yahoo-inc.com>
	<87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost>
	<20091230052402.GB26364@localhost>
Date: Wed, 30 Dec 2009 19:02:38 +0100
In-Reply-To: <20091230052402.GB26364@localhost> (Wu Fengguang's message of "Wed, 30 Dec 2009 13:24:02 +0800")
Message-ID: <873a2s8hmp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> writes:
>   * the ra fields can be accessed concurrently in a racy way.
> --- linux.orig/mm/fadvise.c	2009-12-30 13:02:03.000000000 +0800
> +++ linux/mm/fadvise.c	2009-12-30 13:23:05.000000000 +0800
> @@ -77,12 +77,14 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
>  	switch (advice) {
>  	case POSIX_FADV_NORMAL:
>  		file->f_ra.ra_pages = bdi->ra_pages;
> +		file->f_ra.flags &= ~RA_FLAG_RANDOM;
>  		break;
>  	case POSIX_FADV_RANDOM:
> -		file->f_ra.ra_pages = 0;
> +		file->f_ra.flags |= RA_FLAG_RANDOM;

What prevents this from racing with a parallel readahead
state modification, losing the bits?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
