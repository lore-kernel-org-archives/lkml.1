Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbZCMUwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbZCMUwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 16:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbZCMUwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 16:52:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47223
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbZCMUwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 16:52:30 -0400
Date: Fri, 13 Mar 2009 13:52:16 -0700 (PDT)
Message-Id: <20090313.135216.19807120.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: akpm@linux-foundation.org, yann.poupet@free.fr,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PROBLEM]: potential unaligned memory access in
 drivers/usb/gadget/rndis.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1236901897.4036.1.camel@brick>
References: <3848726.1723791236775868071.JavaMail.root@spooler2-g27.priv.proxad.net>
	<20090311235119.f4609775.akpm@linux-foundation.org>
	<1236901897.4036.1.camel@brick>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Thu, 12 Mar 2009 16:51:37 -0700

> On Wed, 2009-03-11 at 23:51 -0700, Andrew Morton wrote:
> 
> > Maybe the below fixed this?  afacit it is queued for 2.6.30 in the
> > net-next tree: 
> > 
> > commit 35c26c2cf6a6a2d1c48add732d8ba002bd90784c
> > Author:     Harvey Harrison <harvey.harrison@gmail.com>
> > AuthorDate: Sat Feb 14 22:56:56 2009 -0800
> > Commit:     David S. Miller <davem@davemloft.net>
> > CommitDate: Sat Feb 14 22:56:56 2009 -0800
> > 
> >     rndis: remove private wrapper of __constant_cpu_to_le32
> >     
> >     Use cpu_to_le32 directly as it handles constant folding now, replace direct
> >     uses of __constant_cpu_to_{endian} as well.
> >     
> >     Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> >     Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> 
> Doubtful, this patch should be a no-op, any alignment problems that existed
> before will still be there.

Agreed, that patch won't do anything wrt. the alignment issue being
reported here.
