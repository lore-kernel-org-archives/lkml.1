Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbZENIeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbZENIeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 04:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbZENIeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 04:34:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42428 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbZENIeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 04:34:12 -0400
Subject: Re: [Xen-devel] Performance overhead of paravirt_ops on
 nativeidentified
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jun Nakajima <jun.nakajima@intel.com>,
       Xiaohui Xin <xiaohui.xin@intel.com>, Xin Li <xin.li@intel.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4A0BED040200007800000DB0@vpn.id2.novell.com>
References: <4A0B62F7.5030802@goop.org>
	 <4A0BED040200007800000DB0@vpn.id2.novell.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 10:33:59 +0200
Message-Id: <1242290039.6642.919.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 09:05 +0100, Jan Beulich wrote:
> Wouldn't a third solution be to use ticket spinlocks everywhere, i.e. eliminate
> the current indirection, and replace it by an indirection for just the contention
> case? As I view it, the problem for Xen aren't really the ticket locks by
> themselves, but rather the extra spinning involved, which is of concern only
> if a lock is contended. We're using ticket locks quite happily in our kernels,
> with directed instead of global wakeup from the unlock path. The only open
> issue we currently have is that while for native keeping interrupts disabled
> while spinning may be acceptable (though I'm not sure how -rt folks are
> viewing this), in a pv environment one should really re-enable interrupts
> here due to the potentially much higher latency.

the -rt folks don't nearly have as many spinlocks, and for those we do
like ticket locks, because they are much fairer and give better worst
case contention behaviour.

Also, for the -rt folks, preempt disable is about as bad as irq disable.

