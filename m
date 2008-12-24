Return-Path: <linux-kernel-owner+w=401wt.eu-S1751801AbYLXRsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbYLXRsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 12:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbYLXRsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 12:48:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57991 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYLXRsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 12:48:31 -0500
Message-ID: <49527590.7090909@vlnb.net>
Date: Wed, 24 Dec 2008 20:46:56 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-scsi@vger.kernel.org,
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
       David Miller <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: Re: [PATCH][RFC 23/23]: Support for zero-copy TCP transmit of user
 space data
References: <494C50BB.5030809@goop.org> <20081220020250.GA15064@gondor.apana.org.au> <494C8D57.7040808@goop.org> <20081220065105.GA16936@gondor.apana.org.au> <494CA226.9000200@goop.org> <20081220081045.GA17439@gondor.apana.org.au> <20081220103209.GA23632@ioremap.net> <49513909.1050100@vlnb.net> <20081223213817.GB16883@ioremap.net> <4952493F.10508@vlnb.net> <20081224144422.GA25089@ioremap.net>
In-Reply-To: <20081224144422.GA25089@ioremap.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19rxZvZRA3OdGHZiUhiVkt0SFKzITmPatfyUKn
 NIX9sAi/yU85QD0OReeFK1ucc/SYKeGc//LqGc5CuWL3AMu97D
 fSr24xpg2Gl8dxPUcMs1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov, on 12/24/2008 05:44 PM wrote:
> On Wed, Dec 24, 2008 at 05:37:51PM +0300, Vladislav Bolkhovitin (vst@vlnb.net) wrote:
>>> Yes, it is simpler and cleaner, but it requires additional allocation.
>>> This is additional (and quite noticeble) overhead.
>> Not necessary requires. For instance, in iscsi-scst sk_transaction_token 
>> can (and should) be part of iSCSI cmd structure, so no additional 
>> allocations would be needed.
> 
> This is special case, I'm not sure it is always possible to cache that
> token and attach to every skb, but if it can be done, then of course
> this does not end up with additional overhead.

I think in most cases there would be possibility to embed 
sk_transaction_token to some higher level structure. E.g. Xen apparently 
should have something to track packets passed through host/guest 
boundary. From other side, kmem cache is too well polished to have much 
overhead. I doubt, you would even notice it in this application. In most 
cases allocation of such small object in it using SLUB is just about the 
same as a list_del() under disabled IRQs.

Vlad



