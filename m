Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYBVLyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYBVLyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 06:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYBVLxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 06:53:53 -0500
Received: from mx1.suse.de ([195.135.220.2]:33955 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbYBVLxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 06:53:52 -0500
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Tejun Heo <htejun@gmail.com>, rusty@rustcorp.com.au,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Module loading/unloading and "The Stop Machine"
From: Andi Kleen <andi@firstfloor.org>
References: <47ABC08C.8010101@qualcomm.com> <47B3BD51.1080706@gmail.com>
	<47BE245F.3030809@qualcomm.com> <47BE27AE.8050009@gmail.com>
	<47BE29A0.6040409@qualcomm.com>
Date: Fri, 22 Feb 2008 12:53:50 +0100
In-Reply-To: <47BE29A0.6040409@qualcomm.com> (Max Krasnyanskiy's message of "Thu\, 21 Feb 2008 17\:47\:12 -0800")
Message-ID: <p73prup8awh.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyanskiy <maxk@qualcomm.com> writes:
>
> static struct module *load_module(void __user *umod,
>                                  unsigned long len,
>                                  const char __user *uargs)
> {
>      ...
>
>      /* Now sew it into the lists so we can get lockdep and oops
>         * info during argument parsing.  Noone should access us, since
>         * strong_try_module_get() will fail. */
>        stop_machine_run(__link_module, mod, NR_CPUS);
>      ...
> }

Wow you found some really bad code. I bet it wouldn't be that
difficult to fix the code to allow oops safe list insertion
without using the big stop machine overkill hammer.

-Andi
