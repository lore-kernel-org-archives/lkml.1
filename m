Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbXKLJpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbXKLJpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 04:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXKLJpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 04:45:30 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43107 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbXKLJp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 04:45:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Check length at deprecated_sysctl_warning.
References: <200711080257.lA82vQfA015942@www262.sakura.ne.jp>
	<20071107192211.c1c22e97.akpm@linux-foundation.org>
	<200711080819.lA88J8Pv072259@www262.sakura.ne.jp>
Date: Mon, 12 Nov 2007 02:44:36 -0700
In-Reply-To: <200711080819.lA88J8Pv072259@www262.sakura.ne.jp> (Tetsuo Handa's
	message of "Thu, 08 Nov 2007 17:19:08 +0900")
Message-ID: <m14pfr6bnf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> writes:

> Hello.
>
> Thanks for reformatting my patch
> and sorry for surprising you with directory name
> (I meant to type linux-2.6.24-rc2, not linux-2.6.22-rc2).
>
> According to linux-2.6.23,
> it seems that I should return -ENOTDIR
> for invalid args->nlen value.
>
> I got a question here regarding interpretation of CTL_MAXNAME .
> Is args->nlen == CTL_MAXNAME valid?
> It is treated as invalid while the definition says
>
>   /* how many path components do we allow in a
>      call to sysctl?   In other words, what is
>      the largest acceptable value for the nlen
>      member of a struct __sysctl_args to have? */
>
> If "name[CTL_MAXNAME];" is what the author intended,
> I think args->nlen == CTL_MAXNAME is valid.

name[CTL_MAXNAME} is not valid.
name[0...CTL_MAXNAME-1] is valid.


The check that got lost in the refactoring was specfically:

-       if (tmp.nlen <= 0 || tmp.nlen >= CTL_MAXNAME)
-               return -ENOTDIR;

Eric

