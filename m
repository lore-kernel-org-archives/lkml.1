Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbXJNTYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbXJNTYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 15:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXJNTYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 15:24:41 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:47572 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbXJNTYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 15:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MyZDG4SHXmfumbLabtG/EEH/26EHfrq/rKheDVrv9wK4giJXjaOn7HsAit67FedKQV2buLExGIXCV4bcoW8belLNC4uXDdPkW7W2h/Dar4ckTESJGfPnqTtP9FWiQC+OpmS2y+DH+ufJwuwTZGYFt/BOLygen5raT9aRWhP9IJI=
Message-ID: <2a382c6e0710141224n2b8a47c8v1346f1a9dedc7943@mail.gmail.com>
Date: Sun, 14 Oct 2007 23:24:39 +0400
From: "Dave Milter" <davemilter@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: linux-2.6.23-mm1 crashed
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <2a382c6e0710141145j51286bd0o8a2eb307f7455cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2a382c6e0710141145j51286bd0o8a2eb307f7455cd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, because of oops happens on early stage of boot,
you not need any image to reproduce this bug:
something like this will be enough:
1)cd /tmp/ && qemu-img create hda.img 10M
2)cd linux/mm/source/code
3)qemu -kernel arch/i386/boot/bzImage -hda /tmp/hda.img

if you add "-s" to qemu options you can after that do:
gdb vmlinux
$target remote localhost:1234
$br gth_timeout
$continue

On 10/14/07, Dave Milter <davemilter@gmail.com> wrote:
> I build linux-2.6.23-mm1 and try to boot it using qemu,
> and it crashed with trace like this:
> do_page_fault
> error_code
> lock_acquire
> _spin_lock_irqsave
> gdth_timeout
> run_timer_softirq
> __do_softirq
> do_softirq
>
> I have screenshot, but have no idea, is it legal to include it, if I
> sent copy to lkml.
> config of kernel in attachment,
> I apply all three patches from hot-fixes.
>
>
