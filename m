Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZA1MZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZA1MZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 07:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbZA1MY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 07:24:56 -0500
Received: from ozlabs.org ([203.10.76.45]:52146 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZA1MY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 07:24:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] module: kzalloc mod->ref
Date: Wed, 28 Jan 2009 22:54:50 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@redhat.com>,
       Tejun Heo <tj@kernel.org>, Kyle McMartin <kyle@infradead.org>,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
References: <20090114033533.GL25103@bombadil.infradead.org> <200901271206.51248.rusty@rustcorp.com.au> <20090127131534.GG23121@elte.hu>
In-Reply-To: <20090127131534.GG23121@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901282254.51238.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009 23:45:34 Ingo Molnar wrote:
> 
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > @@ -344,8 +339,11 @@ struct module
> >  	/* Destruction function. */
> >  	void (*exit)(void);
> >  
> > -	/* Reference counts */
> > -	struct module_ref ref[NR_CPUS];
> > +#ifdef CONFIG_SMP
> > +	char *refptr;
> > +#else
> > +	local_t ref;
> > +#endif
> 
> hm, that construct looks rather ugly. Is there no way to provide a clean 
> data type and APIs for this that just work symmetrically on both SMP and 
> UP?

Part of me agreed when I first read it, but unification means UP would do an alloc as well.  Neater, but less efficient.

But maybe these days UP means embedded, and hence no modules anyway :)

Hope that clarifies,
Rusty.
