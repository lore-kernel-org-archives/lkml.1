Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbZJNQMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbZJNQMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761924AbZJNQMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:12:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52823 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934423AbZJNQMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:12:16 -0400
Date: Wed, 14 Oct 2009 17:12:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gregkh@suse.de, tglx@linutronix.de
Cc: tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gregkh@suse.de
Subject: Re: [tip:bkl/drivers] drivers: Remove BKL from misc_open
Message-ID: <20091014171249.57dcdcfc@lxorguk.ukuu.org.uk>
In-Reply-To: <tip-40b798efe3460797a4ac928ee2e038774e2758eb@git.kernel.org>
References: <20091010153349.237173041@linutronix.de>
	<tip-40b798efe3460797a4ac928ee2e038774e2758eb@git.kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009 15:47:39 GMT
tip-bot for Thomas Gleixner <tglx@linutronix.de> wrote:

> Commit-ID:  40b798efe3460797a4ac928ee2e038774e2758eb
> Gitweb:     http://git.kernel.org/tip/40b798efe3460797a4ac928ee2e038774e2758eb
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Sat, 10 Oct 2009 15:35:43 +0000
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 14 Oct 2009 17:33:32 +0200
> 
> drivers: Remove BKL from misc_open
> 
> misc_open() is already serialized with misc_mtx. Remove the BKL
> locking which got there via the BKL pushdown.

NAK.

You can't simply assume the mutex is enough - you have to either push it
down or review *every* possible called point below the lock_kernel take.

In this case the open method of the misc devices below sometimes uses the
BKL.
