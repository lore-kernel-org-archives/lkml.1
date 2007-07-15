Return-Path: <linux-kernel-owner+w=401wt.eu-S933357AbXGOBue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbXGOBue (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 21:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765898AbXGOBu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 21:50:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50142
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763574AbXGOBu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 21:50:26 -0400
Date: Sat, 14 Jul 2007 18:50:28 -0700 (PDT)
Message-Id: <20070714.185028.130236895.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de,
       chrisw@sous-sol.org, IvDoorn@gmail.com, dtor@mail.ru
Subject: Re: [patch] net/input: fix net/rfkill/rfkill-input.c bug on 64-bit
 systems
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070712124503.GA16633@elte.hu>
References: <20070712124503.GA16633@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 12 Jul 2007 14:45:03 +0200

> From: Ingo Molnar <mingo@elte.hu>
> Subject: [patch] net/input: fix net/rfkill/rfkill-input.c bug on 64-bit systems
> 
> this recent commit:
> 
>  commit cf4328cd949c2086091c62c5685f1580fe9b55e4
>  Author: Ivo van Doorn <IvDoorn@gmail.com>
>  Date:   Mon May 7 00:34:20 2007 -0700
> 
>      [NET]: rfkill: add support for input key to control wireless radio
> 
> added this 64-bit bug:
> 
>         ....
> 	unsigned int flags;
>  
>  	spin_lock_irqsave(&task->lock, flags);
>         ....
> 
> irq 'flags' must be unsigned long, not unsigned int. The -rt tree has 
> strict checks about this on 64-bit so this triggered a build failure. 
> 
> For -stable too i suspect.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Applied, thanks Ingo.

I'll push this to -stable.
