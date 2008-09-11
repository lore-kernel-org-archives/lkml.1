Return-Path: <linux-kernel-owner+w=401wt.eu-S1751380AbYIKEYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbYIKEYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 00:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYIKEY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 00:24:29 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:47763 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbYIKEY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 00:24:28 -0400
Date: Thu, 11 Sep 2008 08:23:46 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage release.
Message-ID: <20080911042345.GA8570@2ka.mipt.ru>
References: <20080909113817.GA14005@2ka.mipt.ru> <alpine.LNX.2.00.0809110054020.1542@titan.stealer.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0809110054020.1542@titan.stealer.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sven.

On Thu, Sep 11, 2008 at 01:51:44AM +0200, Sven Wegener (sven.wegener@stealer.net) wrote:
> > +static void *dst_crypto_thread_init(void *data)
> > +{
> > +	struct dst_node *n = data;
> > +	struct dst_crypto_engine *e;
> > +	int err = -ENOMEM;
> > +
> > +	e = kzalloc(sizeof(struct dst_crypto_engine), GFP_KERNEL);
> > +	if (!e)
> > +		goto err_out_exit;
> > +	e->src = kzalloc(sizeof(struct scatterlist) * 2 * n->max_pages,
> > +			GFP_KERNEL);
> > +	if (!e->src)
> > +		goto err_out_free;
> > +
> > +	e->dst = e->src + n->max_pages;
> > +
> > +	err = dst_crypto_engine_init(e, n);
> > +	if (err)
> > +		goto err_out_free;
> > +
> > +	return e;
> > +
> > +err_out_free:
> > +	kfree(e->src);
> 
> You leak the memory allocated for e here.

Thanks a lot for pointing this out, I will fix it.

-- 
	Evgeniy Polyakov
