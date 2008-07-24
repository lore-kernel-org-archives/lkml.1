Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbYGXLH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbYGXLH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYGXLHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:07:10 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:43536 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751599AbYGXLHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:07:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VXX0w2pqnfx+HGmJ7q2NM6j27Oa47SPRati9DD3AD05Ix0VsDmZ74cH8HN/0tW5/9WnJhqRZXYTqcE1VEDGW3TD0xcGrv/4K9WR5nW+ad/7PcmCHjd6IZ65R2IEP4SK1C9qYswuwQdSJn6U8rT7Yk99/53lZ8FGJ5KFlSUyg+Kc=  ;
X-YMail-OSG: 6LzUmEQVM1lZtqnMmbZcAkFWV5nTg9d2SWFySezXyAIjWiEl62wWqp3NiDXYp9LZBvPeRgEfFsih1AiTnCMzbQdSt1ChubyYzKw_1ziHrb8OMwA3KZrIJbPEojK9cJZ9GoA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Kernel WARNING: at net/core/dev.c:1330 __netif_schedule+0x2c/0x98()
Date: Thu, 24 Jul 2008 21:06:51 +1000
User-Agent: KMail/1.9.5
Cc: peterz@infradead.org, davem@davemloft.net, jarkao2@gmail.com,
       Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com,
       paulmck@linux.vnet.ibm.com
References: <1216890648.7257.258.camel@twins> <200807242038.36693.nickpiggin@yahoo.com.au> <E1KLyUI-0006ZS-Cg@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KLyUI-0006ZS-Cg@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807242106.52672.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008 20:55, Miklos Szeredi wrote:
> On Thu, 24 Jul 2008, Nick Piggin wrote:
> > Hey, something kind of cool (and OT) I've just thought of that we can
> > do with ticket locks is to take tickets for 2 (or 64K) nested locks,
> > and then wait for them both (all), so the cost is N*lock + longest spin,
> > rather than N*lock + N*avg spin.
>
> Isn't this deadlocky?
>
> E.g. one task takes ticket x=1, then other task comes in and takes x=2
> and y=1, then first task takes y=2.  Then neither can actually
> complete both locks.

Oh duh of course you still need mutual exclusion from the first lock
to order the subsequent :P

So yeah it only works for N > 2 locks, and you have to spin_lock the
first one... so unsuitable for scheduler.
