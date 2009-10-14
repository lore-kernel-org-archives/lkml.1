Return-Path: <linux-kernel-owner+w=401wt.eu-S1761966AbZJNQIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761966AbZJNQIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934423AbZJNQIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:08:51 -0400
Received: from www.tglx.de ([62.245.132.106]:46107 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761957AbZJNQIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:08:50 -0400
Date: Wed, 14 Oct 2009 18:07:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arndbergmann@googlemail.com>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:bkl/drivers] drivers: Remove BKL from misc_open
In-Reply-To: <200910141755.00774.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.0910141807090.9428@localhost.localdomain>
References: <20091010153349.237173041@linutronix.de> <tip-40b798efe3460797a4ac928ee2e038774e2758eb@git.kernel.org> <200910141755.00774.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Arnd Bergmann wrote:
> On Wednesday 14 October 2009, tip-bot for Thomas Gleixner wrote:
> > Commit-ID:  40b798efe3460797a4ac928ee2e038774e2758eb
> > Gitweb:     http://git.kernel.org/tip/40b798efe3460797a4ac928ee2e038774e2758eb
> > Author:     Thomas Gleixner <tglx@linutronix.de>
> > AuthorDate: Sat, 10 Oct 2009 15:35:43 +0000
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Wed, 14 Oct 2009 17:33:32 +0200
> > 
> > drivers: Remove BKL from misc_open
> > 
> > misc_open() is already serialized with misc_mtx. Remove the BKL
> > locking which got there via the BKL pushdown.
> 
> Did you check the misc drivers to make sure this is not silently
> removing the BKL from drivers that need it?

Yep, they are plastered with cycle_kernel_lock and lock/unlock_kernel
already. I might have missed some, but ...

Thanks,

	tglx


