Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYGXK4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYGXK4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYGXK4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:56:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46841 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYGXK4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:56:13 -0400
To: nickpiggin@yahoo.com.au
CC: peterz@infradead.org, davem@davemloft.net, jarkao2@gmail.com,
       Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com,
       paulmck@linux.vnet.ibm.com
In-reply-to: <200807242038.36693.nickpiggin@yahoo.com.au> (message from Nick
	Piggin on Thu, 24 Jul 2008 20:38:35 +1000)
Subject: Re: Kernel WARNING: at net/core/dev.c:1330 __netif_schedule+0x2c/0x98()
References: <1216890648.7257.258.camel@twins> <20080724.023210.229338550.davem@davemloft.net> <1216894136.7257.266.camel@twins> <200807242038.36693.nickpiggin@yahoo.com.au>
Message-Id: <E1KLyUI-0006ZS-Cg@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Jul 2008 12:55:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008, Nick Piggin wrote:
> Hey, something kind of cool (and OT) I've just thought of that we can
> do with ticket locks is to take tickets for 2 (or 64K) nested locks,
> and then wait for them both (all), so the cost is N*lock + longest spin,
> rather than N*lock + N*avg spin.

Isn't this deadlocky?

E.g. one task takes ticket x=1, then other task comes in and takes x=2
and y=1, then first task takes y=2.  Then neither can actually
complete both locks.

Miklos
