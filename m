Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbYLXSI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbYLXSI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 13:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYLXSIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 13:08:45 -0500
Received: from kandzendo.ru ([195.178.208.66]:48645 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYLXSIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 13:08:44 -0500
Date: Wed, 24 Dec 2008 21:08:41 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
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
Subject: Re: [PATCH][RFC 23/23]: Support for zero-copy TCP transmit of user space data
Message-ID: <20081224180841.GA615@ioremap.net>
References: <494C8D57.7040808@goop.org> <20081220065105.GA16936@gondor.apana.org.au> <494CA226.9000200@goop.org> <20081220081045.GA17439@gondor.apana.org.au> <20081220103209.GA23632@ioremap.net> <49513909.1050100@vlnb.net> <20081223213817.GB16883@ioremap.net> <4952493F.10508@vlnb.net> <20081224144422.GA25089@ioremap.net> <49527590.7090909@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49527590.7090909@vlnb.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 08:46:56PM +0300, Vladislav Bolkhovitin (vst@vlnb.net) wrote:
> I think in most cases there would be possibility to embed 
> sk_transaction_token to some higher level structure. E.g. Xen apparently 
> should have something to track packets passed through host/guest 
> boundary. From other side, kmem cache is too well polished to have much 
> overhead. I doubt, you would even notice it in this application. In most 
> cases allocation of such small object in it using SLUB is just about the 
> same as a list_del() under disabled IRQs.

I definitely would not rely on that, especially at cache reclaim time.
But it of course depends on the workload and maybe appropriate for the
cases in question. The best solution I think is to combine tag and
separate destructur, so that those who do not want to allocate a token
could still get notification via destructor callback.

-- 
	Evgeniy Polyakov
