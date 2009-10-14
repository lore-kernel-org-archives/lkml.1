Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbZJNTfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbZJNTfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759121AbZJNTfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:35:21 -0400
Received: from www.tglx.de ([62.245.132.106]:45549 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbZJNTfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:35:20 -0400
Date: Wed, 14 Oct 2009 21:34:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:bkl/drivers] drivers: Remove BKL from misc_open
In-Reply-To: <20091014191223.35ba4004@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0910142133550.9428@localhost.localdomain>
References: <20091010153349.237173041@linutronix.de> <tip-40b798efe3460797a4ac928ee2e038774e2758eb@git.kernel.org> <20091014171249.57dcdcfc@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0910141816020.9428@localhost.localdomain>
 <20091014191223.35ba4004@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Alan Cox wrote:
> On Wed, 14 Oct 2009 18:16:58 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > on Wed, 14 Oct 2009, Alan Cox wrote:
> > > On Wed, 14 Oct 2009 15:47:39 GMT
> > > tip-bot for Thomas Gleixner <tglx@linutronix.de> wrote:
> > > 
> > > > Commit-ID:  40b798efe3460797a4ac928ee2e038774e2758eb
> > > > Gitweb:     http://git.kernel.org/tip/40b798efe3460797a4ac928ee2e038774e2758eb
> > > > Author:     Thomas Gleixner <tglx@linutronix.de>
> > > > AuthorDate: Sat, 10 Oct 2009 15:35:43 +0000
> > > > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > > > CommitDate: Wed, 14 Oct 2009 17:33:32 +0200
> > > > 
> > > > drivers: Remove BKL from misc_open
> > > > 
> > > > misc_open() is already serialized with misc_mtx. Remove the BKL
> > > > locking which got there via the BKL pushdown.
> > > 
> > > NAK.
> > > 
> > > You can't simply assume the mutex is enough - you have to either push it
> > > down or review *every* possible called point below the lock_kernel take.
> > > 
> > > In this case the open method of the misc devices below sometimes uses the
> > > BKL.
> > 
> > The BKL got pushed down into the open methods of misc dev users and we
> > do not need to take it twice in a row, right ?
> 
> Then the comment is misleading and you need to document that you've
> already pushed the BKL down into each user and checked them.

Fair enough. I fix that.

     tglx
