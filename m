Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbYLTB43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbYLTB43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 20:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYLTB4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 20:56:17 -0500
Received: from gw.goop.org ([64.81.55.164]:33399 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbYLTB4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 20:56:15 -0500
Message-ID: <494C50BB.5030809@goop.org>
Date: Fri, 19 Dec 2008 17:56:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>, netdev@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH][RFC 23/23]: Support for zero-copy TCP transmit of user
 space data
References: <494009D7.4020602@vlnb.net> <494012C4.7090304@vlnb.net> <494C0255.8010208@goop.org> <20081219220452.GB704@ioremap.net> <494C1E5E.7070809@goop.org> <20081219223314.GA2736@ioremap.net>
In-Reply-To: <20081219223314.GA2736@ioremap.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Shared info is freed when there are no skbs referring to the shared info
> in question. Skb holds all pages in shared info in the fraglist array,
> so when it is about to be freed, it means that network stack does not
> use it (particulary it will putpage every page in fraglist). Usually
> there are two skbs in the network stack per packet in TCP (allocated at
> once though via fastclone mechanims): one is provided to the device
> (and will be freed there) and another one is placed into retransmit
> queue, where it will be located and freed when ack has been received.
>
> There may be another layers which may clone skb, but its shared info
> structure (shared between the clones) will only be freed when all users
> freed appropriate cloned skbs.
>   

I see.  One more question: how would I go about submitting some data 
with the callback attached to it?

    J
