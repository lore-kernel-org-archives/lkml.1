Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbYGQMjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbYGQMjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 08:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYGQMjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 08:39:08 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48194 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754193AbYGQMjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:39:07 -0400
Date: Thu, 17 Jul 2008 07:39:06 -0500
From: Robin Holt <holt@sgi.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Robin Holt <holt@sgi.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       cl@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: SLUB: simplify re on_each_cpu()
Message-ID: <20080717123906.GH8534@sgi.com>
References: <20080716172902.GA5176@martell.zuzino.mipt.ru> <20080717113826.GG8534@sgi.com> <84144f020807170526x6f013357i29280595f65a67f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020807170526x6f013357i29280595f65a67f4@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 03:26:46PM +0300, Pekka Enberg wrote:
> Hi Robin,
> 
> On Wed, Jul 16, 2008 at 09:29:02PM +0400, Alexey Dobriyan wrote:
> >> on_each_cpu() expands to function call on UP, too.
> 
> On Thu, Jul 17, 2008 at 2:38 PM, Robin Holt <holt@sgi.com> wrote:
> > It looks to me like on_each_cpu is a #define for !SMP.  Are you certain
> > of the need for this change?  Are you looking at a different tree than
> > Linus'?
> 
> I think it's actually you who is looking at an older tree.

I did a git-checkout of
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
which got me commit id 33af79d12e0fa25545d49e86afc67ea8ad5f2f40
and looked at include/linux/smp.h line 123.  It has:

#define on_each_cpu(func,info,wait)             \
        ({                                      \
                local_irq_disable();            \
                func(info);                     \
                local_irq_enable();             \
                0;                              \
        })

This is the !CONFIG_SMP case (line 111).  When I look at
kernel/softirq.c, I notice immediately prior to the comment the #ifdef
CONFIG_SMP.

They appear equivalent.  What am I missing?

Thanks,
Robin
