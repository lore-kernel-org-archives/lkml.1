Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbZFJMoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbZFJMoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbZFJMoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:44:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45337 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbZFJMoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:44:09 -0400
Subject: Re: [tip:tracing/core] x86, bts: reenable ptrace branch trace
 support
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-7e0bfad24d85de7cf2202a7b0ce51de11a077b21@git.kernel.org>
References: <20090424094448.A30216@sedona.ch.intel.com>
	 <tip-7e0bfad24d85de7cf2202a7b0ce51de11a077b21@git.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 10 Jun 2009 14:44:03 +0200
Message-Id: <1244637843.13761.11786.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 09:25 +0000, tip-bot for Markus Metzger wrote:
> Commit-ID:  7e0bfad24d85de7cf2202a7b0ce51de11a077b21
> Gitweb:     http://git.kernel.org/tip/7e0bfad24d85de7cf2202a7b0ce51de11a077b21
> Author:     Markus Metzger <markus.t.metzger@intel.com>
> AuthorDate: Fri, 24 Apr 2009 09:44:48 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 24 Apr 2009 10:18:51 +0200
> 
> x86, bts: reenable ptrace branch trace support
> 
> The races found by Oleg Nesterov have been fixed.
> 
> Reenable branch trace support.
> 
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> LKML-Reference: <20090424094448.A30216@sedona.ch.intel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

OK, this whole BTS thing worries me because it seems to expose too much
of the Intel Debug Store thingy to the outside world.

The thing is, once we do PEBS from inside the kernel, we'll have to
share the debug store, and the way this thing sets it up isn't really
going to work.

So what I'd like to see is having this debug store removed from the
interface and abstracted away as cpu resource -- a single page when in
use should suffice I think.

If you want to expose a buffer to userspace, use the regular mmap()
interface and fill those pages from the DS interrupt handler.
