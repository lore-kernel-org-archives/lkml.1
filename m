Return-Path: <linux-kernel-owner+w=401wt.eu-S1760599AbXKMDus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599AbXKMDus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 22:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbXKMDuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 22:50:39 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:58382 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbXKMDui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 22:50:38 -0500
Message-Id: <200711130350.lAD3oWnt054039@www262.sakura.ne.jp>
Subject: Re: [PATCH] sysctl: Check length at deprecated_sysctl_warning.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Nov 2007 12:50:32 +0900
References: <200711080257.lA82vQfA015942@www262.sakura.ne.jp> <20071107192211.c1c22e97.akpm@linux-foundation.org> <200711080819.lA88J8Pv072259@www262.sakura.ne.jp> <m14pfr6bnf.fsf@ebiederm.dsl.xmission.com> <200711130307.lAD37Nee045340@www262.sakura.ne.jp> <20071112191320.55e49462.akpm@linux-foundation.org>
In-Reply-To: <20071112191320.55e49462.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:
> I believe (args->nlen > CTL_MAXNAME) was correct.
I'll leave it to you.
But if you want to allow args->nlen == CTL_MAXNAME,
you also need to update do_sysctl().

int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
               void __user *newval, size_t newlen)
{
        ...
        if (nlen <= 0 || nlen >= CTL_MAXNAME)
                return -ENOTDIR;
        ...
}

Thanks.
