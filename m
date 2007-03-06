Return-Path: <linux-kernel-owner+w=401wt.eu-S1030611AbXCFTFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030611AbXCFTFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030608AbXCFTFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:05:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:46381 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030611AbXCFTFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:05:46 -0500
From: Andreas Schwab <schwab@suse.de>
To: "Chen, Dongliang" <Chen.D@ems-t.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: return negative number for unsigned long function in kernel
References: <314BE1148B8C8D468A05944FDF577583069B021E@MRE02.enterprise.com>
X-Yow: While you're chewing, think of STEVEN SPIELBERG'S
 bank account..  This will have the same effect as
 two ``STARCH BLOCKERS''!
Date: Tue, 06 Mar 2007 20:05:38 +0100
In-Reply-To: <314BE1148B8C8D468A05944FDF577583069B021E@MRE02.enterprise.com>
	(Dongliang Chen's message of "Tue, 6 Mar 2007 09:52:34 -0500")
Message-ID: <je4poyp4zh.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Chen, Dongliang" <Chen.D@ems-t.com> writes:

> There are lots of functions in the Linux kernel that are declared as
> unsigned long, but the return value is negative integer while error
> occurred. An example of these functions is do_mmap_pgoff in mm/mmap.c,
> which is defined as:
>
> unsigned long do_mmap_pgoff(....)
>
> In this function, it returns -ENODEV, -EPERM, -ENOMEM, -EINVAL, -EAGAIN,
> -EACCESS depends on the error type. My question is how should the caller
> perform error check based on the return value? 

The return value is directly passed to user space (it's the guts of the
mmap syscall).  The glibc wrapper transforms it appropriately so that
errno is set and -1 is returned if there is an error.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
