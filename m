Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYKFHVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYKFHVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYKFHVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:21:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60052 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbYKFHVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:21:01 -0500
Date: Thu, 6 Nov 2008 08:20:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081106072056.GL15731@elte.hu>
References: <20081105094902.27ec4b39@infradead.org> <20081105194326.GA5839@joi> <20081105123604.633105ca@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105123604.633105ca@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> > > +	buffer = kmalloc(4096, GFP_KERNEL);

> > > +	err = d_path(&file->f_path, buffer, 4096);

hm, magic constants.

> > > +	if (IS_ERR(err))
> > > +		goto out;
> > > +
> > > +	ftrace_printk("Process %s is calling fsync on %s\n",
> > > +			current->comm, err);
> > 
> > err? not buffer?
> 
> correct, not buffer
> 
> it won't work if you use buffer.

please use some other name than 'err' - since "error" is just a 
property of the path string pointer you get back from do_path().

	Ingo
