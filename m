Return-Path: <linux-kernel-owner+w=401wt.eu-S933280AbXCRVt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbXCRVt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 17:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbXCRVt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 17:49:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43722
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933280AbXCRVt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 17:49:27 -0400
Date: Sun, 18 Mar 2007 14:49:27 -0700 (PDT)
Message-Id: <20070318.144927.78708843.davem@davemloft.net>
To: da-x@monatomic.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp_sendpage(): fix broken page iteration
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070318124346.GA6396@localdomain>
References: <20070318124346.GA6396@localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Aloni <da-x@monatomic.org>
Date: Sun, 18 Mar 2007 14:43:46 +0200

> do_tcp_sendpages() should not iterate 'pages' as an array since 
> it is not an array of 'struct page *', but a pointer to a single 
> entity of 'struct page *' passed on the stack as a parameter to 
> tcp_send_page() (hence it would crash if poffset + psize > PAGE_SIZE,
> because pages[1] and beyond most probably not constitutes a valid 
> 'struct page *').

do_tcp_sendpages() should never get passed poffset+psize>PAGE_SIZE,
that would be a bug.

Feel free to add a BUG() check for that if you wish, and a fix for any
caller which violates this.

The code is perfectly fine as-is.  It was originally written to accept
page arrays, but once it was decided that ->sendpage() would only pass
in one page, we simply modified to caller of do_tcp_sendpages() to
accomodate this argument passing change, instead of changing
do_tcp_sendpages() which is totally unnecessary.
