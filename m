Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYH0WX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYH0WX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYH0WXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:23:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49795
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbYH0WXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:23:19 -0400
Date: Wed, 27 Aug 2008 15:23:14 -0700 (PDT)
Message-Id: <20080827.152314.218610441.davem@davemloft.net>
To: andi@firstfloor.org
Cc: dada1@cosmosbay.com, rick.jones2@hp.com, johnpol@2ka.mipt.ru,
       denys@visp.net.lb, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile\
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080827183216.GZ26610@one.firstfloor.org>
References: <20080827165635.GY26610@one.firstfloor.org>
	<48B58E6B.1030302@cosmosbay.com>
	<20080827183216.GZ26610@one.firstfloor.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 27 Aug 2008 20:32:16 +0200

> > Doing the expensive timestamping in a possibly delayed thread (ie some 
> > milliseconds
> > after hardware notification) is wrong/useless.
> 
> We had this discussion earlier, please review the thread I linked to. 
> 
> Note that interrupts can be arbitarily delayed too (both by cli
> and by interrupt mitigation), even on a non RT kernel.

This is a much different kind of delay compared to sleeping for seconds
or longer on the socket lock while a GFP_KERNEL allocation is being
satisfied by swapping tons of crap out to disk.

Your socket solution is not a workable scheme.
