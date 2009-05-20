Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZETQCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZETQCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZETQCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:02:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42194 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbZETQCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:02:04 -0400
Date: Wed, 20 May 2009 17:57:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Split wait_noreap_copyout()
Message-ID: <20090520155715.GA23682@redhat.com>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com> <1242048349-2766-2-git-send-email-v.mayatskih@gmail.com> <87tz3fssv1.wl%vmayatsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tz3fssv1.wl%vmayatsk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, Vitaly Mayatskikh wrote:
>
> At Mon, 11 May 2009 15:25:50 +0200, Vitaly Mayatskikh wrote:
> >
> Oleg has pointed me to broken behaviour here. Previously
> wait_noreap_copyout was doing unconditional put_user and was returning
> EFAULT when infop is NULL. Now it uses copy_wait_opts_to_user, which
> checks infop and return NULL in the same case. This change is visible
> from userspace in waitid() function.

To me, this behaviour change looks like the cleanup (if not fix) too.
But of course, this should be discussed and at least documented in the
changelog.

do_wait() && infop interaction is really strange before the patch.

When do_wait() is called without WNOWAIT, then infop == NULL is fine.

If WNOWAIT is set, we return -EFAULT. Except in WCONTINUED case
infop == NULL is fine again.


Can somebody explain what is the supposed behaviour?


Otherwise, in my opinion this series realy makes the code better,
and afaics it allows to simplify the code more.

Oleg.

