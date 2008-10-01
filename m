Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYJAGk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYJAGk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYJAGkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:40:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYJAGkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:40:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [RFC patch 0/3] signals: add rt_tgsigqueueinfo syscall
In-Reply-To: Thomas Gleixner's message of  Tuesday, 30 September 2008 19:48:52 -0000 <20080930194445.978351700@linutronix.de>
References: <20080930194445.978351700@linutronix.de>
X-Zippy-Says: I feel partially hydrogenated!
Message-Id: <20081001063945.0B44D154215@magilla.localdomain>
Date: Tue, 30 Sep 2008 23:39:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core of this looks fine to me.  Presumably this would be expressed in
userland as pthread_sigqueue.

You are missing compat_sys_rt_tgsigqueueinfo for e.g. the
arch/x86/ia32/ia32entry.S table.

The clean way to do that would be a do_rt_tgsigqueueinfo taking
the siginfo_t * (not __user).  That is, just split out the copy_from_user,
so compat_sys_rt_tgsigqueueinfo does copy_siginfo_from_user32 instead.


Thanks,
Roland

