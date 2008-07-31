Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbYGaMi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbYGaMi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYGaMij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:38:39 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:30437 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751471AbYGaMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:38:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FXXfDvOe2bTXODoHVdPMac/VJeEmJTxcxAiv7ewDbsqHdZ66LcTXx4peQs4I++FO6Wqr4RLnpKcqhqq5LhCyqTJQDKKo9EW4jzIuLX7j9vEYg1qQ8OPXKUVNZ6CbRbAdJhXxbXJpv8c3AWuxTGu5yQKrJd7iCosspU1HBOukwPU=  ;
X-YMail-OSG: S2IBfkwVM1krjuKEBEyeHB8DPp5UpU_P_QYW7OSNkK1yLc2MbxxSujTctIKccF34hInaB_VBdYWC0q0toJfQT8QCTA0w3AqME8ZFWY21hauUsH4pykPJzaKOPtGiCZbfdwc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: Kernel WARNING: at net/core/dev.c:1330 __netif_schedule+0x2c/0x98()
Date: Thu, 31 Jul 2008 22:38:19 +1000
User-Agent: KMail/1.9.5
Cc: jarkao2@gmail.com, johannes@sipsolutions.net, netdev@axxeo.de,
       peterz@infradead.org, Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
References: <20080726131838.GA2873@ami.dom.local> <20080727203757.GA2527@ami.dom.local> <20080731.052932.110299354.davem@davemloft.net>
In-Reply-To: <20080731.052932.110299354.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807312238.20264.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008 22:29, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Sun, 27 Jul 2008 22:37:57 +0200
>
> > Looks like enough to me. (Probably it could even share space with
> > the state.)
>
> So I made some progress on this, three things:
>
> 1) I remember why I choose a to use a bit in my design, it's so that
>    it does not increase the costs of the checks in the fast paths.
>    test_bit(X) && test_bit(Y) can be combined into a single test by
>    the compiler.

Except for the braindead volatile that gets stuck on the bitops pointer.

Last time I complained about this, a lot of noise was made and I think
Linus wanted it to stay around so we could pass volatile pointers to
bitops & co without warnings. I say we should just remove the volatile
and kill any callers that might warn...
