Return-Path: <linux-kernel-owner+w=401wt.eu-S1751339AbZJNEW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbZJNEW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 00:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZJNEW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 00:22:26 -0400
Received: from mail.perches.com ([173.55.12.10]:2127 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbZJNEW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 00:22:26 -0400
Subject: Re: [PATCH] kernel.h: Add a never optimized away pr_dbg for
 printk(KERN_DEBUG pr_fmt(fmt)...)
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0910132031040.1244@chino.kir.corp.google.com>
References: <1255488982.1909.26.camel@Joe-Laptop.home>
	 <alpine.DEB.1.00.0910132031040.1244@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Oct 2009 21:21:49 -0700
Message-Id: <1255494109.1851.7.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 20:34 -0700, David Rientjes wrote:
> On Tue, 13 Oct 2009, Joe Perches wrote:
> > Many developers use a logging message that
> > is printed at KERN_DEBUG level that is always
> > printed regardless of #define DEBUG levels.
> > pr_debug can be optimized away to a null statement.
> > Add a pr_dbg message that prints at KERN_DEBUG
> > level that uses pr_fmt() that can not be optimized
> > to nothing.
> pr_dbg() is horribly misnamed, it doesn't indicate why it exists vs. 
> pr_debug() at all.

Partially true, it's reasonably named because it's very short.

> Future users will undoubtedly use it by mistake when 
> they only really mean for the message to be emitted on DEBUG because 
> they've seen it in other places and haven't checked the implementation.

The cost of using pr_dbg instead of pr_debug isn't high.

The primary benefit is getting an automatic pr_fmt
and shorter code.

> I'd suggest pr_debug_force(), even though it's much longer (although still 
> shorter than printk(KERN_DEBUG)).

pr_dbg allows longer format strings without exceeding 80 chars.

printk(KERN_DEBUG
pr_debug_force
pr_dbg_always
pr_dbg_noopt

Other suggestions?

