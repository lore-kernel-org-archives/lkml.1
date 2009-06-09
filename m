Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZFIRxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZFIRxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbZFIRxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:53:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:60060 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbZFIRw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:52:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 22/27] score: create kernel files signal.c sys_score.c time.c
Date: Tue, 9 Jun 2009 19:52:47 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OF32AB4A20.4574C065-ON482575D0.00243CB1-482575D0.0024AD26@sunplusct.com>
In-Reply-To: <OF32AB4A20.4574C065-ON482575D0.00243CB1-482575D0.0024AD26@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906091952.47842.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19xTtvGsmjN4/bGCw5U8vcTe3N6fsprWT18WAJ
 +SkkMxjefZPH33MzU7TcFjFMOCBf/xmvdYYSItUNy6zgOMKdPw
 oZkq8RSynqiKuITjNrs+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> +asmlinkage long sys_mmap(unsigned long addr, size_t len,
> +                       unsigned long prot, unsigned long flags,
> +                       unsigned long fd, off_t offset)
> +{
> +       int err = -EINVAL;
> +
> +       if (offset & ~PAGE_MASK) {
> +               printk(KERN_INFO "no pagemask in mmap\r\n");
> +               goto out;
> +       }
> +
> +       err = sys_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
> +out:
> +       return err;
> +}

A 32 bit kernel should only need sys_mmap2, not sys_mmap, because it is
trivial to convert in user space.

> +
> +asmlinkage long score_vfork(struct pt_regs *regs)
> +{
> +       return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->regs[0],
> +                                               regs, 0, NULL, NULL);
> +}
> +
> +/*
> + * Fork a new task - this creates a new program thread.
> + * This is called indirectly via a small wrapper
> + */
> +asmlinkage int
> +score_fork(struct pt_regs *regs)
> +{
> +       return do_fork(SIGCHLD, regs->regs[0], regs, 0, NULL, NULL);
> +}

Similarly, you should not need vfork and fork any more, because they can
be handled in user space through clone().

	Arnd <><
