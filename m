Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbZCXJsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbZCXJsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbZCXJsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:48:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50912 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518AbZCXJse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:48:34 -0400
Date: Tue, 24 Mar 2009 10:48:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] blktrace: print human-readable act_mask
Message-ID: <20090324094814.GA23208@elte.hu>
References: <49C893FC.9080905@cn.fujitsu.com> <49C89488.4030604@cn.fujitsu.com> <49C8AB42.1000802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C8AB42.1000802@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> > @@ -1432,9 +1456,11 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
> >  	if (attr == &dev_attr_act_mask) {
> >  		if (sscanf(buf, "%llx", &value) != 1) {
> >  			/* Assume it is a list of trace category names */
> > -			value = blk_str2act_mask(buf);
> > -			if (value < 0)
> > +			value = blk_trace_str2mask(buf);
> > +			if (value < 0) {
> > +				ret = value;
> >  				goto out;
> > +			}
> 
> value is u64, it can < 0.

Ok. Small nit: please in such cases change the subject line back to 
something like:

  [PATCH 5/5, v2] blktrace: print human-readable act_mask

So that's it's easy to see which is the latest version, in thread 
view.

	Ingo
