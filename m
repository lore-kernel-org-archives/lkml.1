Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbYA2ErU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbYA2ErU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 23:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbYA2ErN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 23:47:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42554
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755495AbYA2ErM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 23:47:12 -0500
Date: Mon, 28 Jan 2008 20:47:29 -0800 (PST)
Message-Id: <20080128.204729.194426943.davem@davemloft.net>
To: jmorris@namei.org
Cc: herbert@gondor.apana.org.au, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [AUDIT]: Increase skb->truesize in audit_expand
From: David Miller <davem@davemloft.net>
In-Reply-To: <Xine.LNX.4.64.0801290112300.12951@us.intercode.com.au>
References: <20080128111018.GA6442@gondor.apana.org.au>
	<Xine.LNX.4.64.0801290112300.12951@us.intercode.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Morris <jmorris@namei.org>
Date: Tue, 29 Jan 2008 01:13:03 +1100 (EST)

> On Mon, 28 Jan 2008, Herbert Xu wrote:
> 
> > Hi:
> > 
> > [AUDIT]: Increase skb->truesize in audit_expand
> > 
> > The recent UDP patch exposed this bug in the audit code.  It
> > was calling pskb_expand_head without increasing skb->truesize.
> > The caller of pskb_expand_head needs to do so because that function
> > is designed to be called in places where truesize is already fixed
> > and therefore it doesn't update its value.
> > 
> > Because the audit system is using it in a place where the truesize
> > has not yet been fixed, it needs to update its value manually.
> > 
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Acked-by: James Morris <jmorris@namei.org>
> 
> 
> (Candidate for stable ?)

Applied, and yes I'll queue this up for -stable.
