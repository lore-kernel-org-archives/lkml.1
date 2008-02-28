Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbYB1TYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbYB1TYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762528AbYB1TX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:23:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46205
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761974AbYB1TXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:23:55 -0500
Date: Thu, 28 Feb 2008 11:23:55 -0800 (PST)
Message-Id: <20080228.112355.15717375.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: Daniel.Beschorner@facton.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: zlib oops with ipcomp in 2.6.24
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080228175011.GA17185@gondor.apana.org.au>
References: <20080223000328.3a71e858.akpm@linux-foundation.org>
	<3C59DB883F7B0B4D8096010D45ACCD134F2112@exch.facton.local>
	<20080228175011.GA17185@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 29 Feb 2008 01:50:11 +0800

> [IPCOMP]: Disable BH on output when using shared tfm
> 
> Because we use shared tfm objects in order to conserve memory,
> (each tfm requires 128K of vmalloc memory), BH needs to be turned
> off on output as that can occur in process context.
> 
> Previously this was done implicitly by the xfrm output code.
> That was lost when it became lockless.  So we need to add the
> BH disabling to IPComp directly.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks Herbert.

The xfrm output lockless stuff is only in 2.6.25, so
we should not need this for -stable right?
