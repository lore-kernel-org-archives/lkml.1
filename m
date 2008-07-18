Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbYGRHMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbYGRHMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYGRHMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:12:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36581
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752697AbYGRHME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:12:04 -0400
Date: Fri, 18 Jul 2008 00:12:02 -0700 (PDT)
Message-Id: <20080718.001202.193698926.davem@davemloft.net>
To: vegard.nossum@gmail.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       penberg@cs.helsinki.fi, rjw@sisk.pl
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
 overwritten
From: David Miller <davem@davemloft.net>
In-Reply-To: <19f34abd0807180003m7bdf832g141777751d7ea563@mail.gmail.com>
References: <19f34abd0807171615s5b477d4cr22d3e9444bcf65df@mail.gmail.com>
	<20080717.190315.186892939.davem@davemloft.net>
	<19f34abd0807180003m7bdf832g141777751d7ea563@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Vegard Nossum" <vegard.nossum@gmail.com>
Date: Fri, 18 Jul 2008 09:03:50 +0200

> > It's supposed to be 0x6b, this would be a "--"
> 
> You're right! Oops. In my defence, I wrote that at 2 AM last night ;-)
> 
> > Also it (more likely IMHO) could be clearing a flag with the value 0x01.
> 
> It could be. But like I said in a later e-mail, the thing is likely
> sk_buff->truesize. Which is not a flags variable. It _is_ however, a
> counter, which is frequently -= and atomic_sub()ed.

skb->truesize is ever incremented or decremented by only one.

Usually it is changed by the entire packet size, or at least one MSS's
worth.

On packet free, it will be decremented by at least sizeof(struct sk_buff)
