Return-Path: <linux-kernel-owner+w=401wt.eu-S934036AbYD3WIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbYD3WIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbYD3WIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:08:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53219
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753496AbYD3WId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:08:33 -0400
Date: Wed, 30 Apr 2008 15:08:32 -0700 (PDT)
Message-Id: <20080430.150832.107441339.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: akpm@linux-foundation.org, jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] net: fix returning void-valued expression
 warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209593023.24729.117.camel@brick>
References: <1209593023.24729.117.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Wed, 30 Apr 2008 15:03:43 -0700

> drivers/net/8390.c:37:2: warning: returning void-valued expression
> drivers/net/bnx2.c:1635:3: warning: returning void-valued expression
> drivers/net/xen-netfront.c:1806:2: warning: returning void-valued expression
> net/ipv4/tcp_hybla.c:105:3: warning: returning void-valued expression
> net/ipv4/tcp_vegas.c:171:3: warning: returning void-valued expression
> net/ipv4/tcp_veno.c:123:3: warning: returning void-valued expression
> net/sysctl_net.c:85:2: warning: returning void-valued expression
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

I wish this weren't marked with a warning, what spits this out,
sparse?

I know the kernel is written in C and not C++, but even Stroustrup
mentions this case explicitly in his book:

	 A void function cannot return a value.  However, a call of a
	 void function doesn't yield a value, so a void function can
	 use a call of a void function as the expression in a return
	 statement.

And I see no reason why there's anything wrong with this construct.
