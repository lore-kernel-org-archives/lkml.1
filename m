Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbYE0Nf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbYE0Nf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbYE0NfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:35:14 -0400
Received: from brick.kernel.dk ([87.55.233.238]:16317 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406AbYE0NfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:35:13 -0400
Date: Tue, 27 May 2008 15:35:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: 2.6.26-rc4: RIP __call_for_each_cic+0x20/0x50
Message-ID: <20080527133510.GV7712@kernel.dk>
References: <20080428050145.af036c4f.akpm@linux-foundation.org> <20080428120412.GY12774@kernel.dk> <20080428195509.GA5247@martell.zuzino.mipt.ru> <20080429062116.GA5059@martell.zuzino.mipt.ru> <20080429090604.GK12774@kernel.dk> <20080430221250.GA10150@martell.zuzino.mipt.ru> <20080504190811.GP12774@kernel.dk> <20080504201542.GA1040@martell.zuzino.mipt.ru> <20080510103719.GA4967@martell.zuzino.mipt.ru> <20080527052740.GB28301@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527052740.GB28301@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27 2008, Alexey Dobriyan wrote:
> On Sat, May 10, 2008 at 02:37:19PM +0400, Alexey Dobriyan wrote:
> > > > > > @@ -41,8 +41,8 @@ int put_io_context(struct io_context *ioc)
> > > > > >  		rcu_read_lock();
> > > > > >  		if (ioc->aic && ioc->aic->dtor)
> > > > > >  			ioc->aic->dtor(ioc->aic);
> > > > > > -		rcu_read_unlock();
> > > > > >  		cfq_dtor(ioc);
> > > > > > +		rcu_read_unlock();
> > > > > >  
> > > > > >  		kmem_cache_free(iocontext_cachep, ioc);
> > > > > >  		return 1;
> > > > > 
> > > > > This helps in sense that 3 times bulk cross-compiles finish to the end.
> > > > > You'll hear me if another such oops will resurface.
> > > > 
> > > > Still looking good?
> > > 
> > > Yup!
> > 
> > And this with patch in mainline, again with PREEMPT_RCU.
> 
> Ping, this happened again with 2.6.26-rc4 and PREEMPT_RCU.

Worrisome... Paul, would you mind taking a quick look at cfq
and see if you can detect why breaks with preempt rcu? It's
clearly a use-after-free symptom, but I don't see how it can
happen.

-- 
Jens Axboe

