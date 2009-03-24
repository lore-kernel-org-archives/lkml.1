Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbZCXP4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbZCXP4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbZCXP43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:56:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33393 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543AbZCXP41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:56:27 -0400
Date: Tue, 24 Mar 2009 16:56:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] blktrace: print human-readable act_mask
Message-ID: <20090324155609.GA10365@elte.hu>
References: <49C893FC.9080905@cn.fujitsu.com> <49C89488.4030604@cn.fujitsu.com> <alpine.DEB.2.00.0903241148240.22830@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903241148240.22830@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> 
> On Tue, 24 Mar 2009, Li Zefan wrote:
> >  
> > +static ssize_t blk_trace_mask2str(char *buf, int mask)
> > +{
> > +	int i;
> > +	char *p = buf;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(mask_maps); i++) {
> > +		if (mask & mask_maps[i].mask) {
> > +			p += sprintf(p, "%s%s",
> > +				    (p == buf) ? "" : ",", mask_maps[i].str);
> > +		}
> > +	}
> > +	*p++ = '\n';
> > +
> > +	return (p - buf);
> > +}
> > +
> >  static struct request_queue *blk_trace_get_queue(struct block_device *bdev)
> >  {
> >  	if (bdev->bd_disk == NULL)
> > @@ -1399,7 +1423,7 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
> >  	if (q->blk_trace == NULL)
> >  		ret = sprintf(buf, "disabled\n");
> >  	else if (attr == &dev_attr_act_mask)
> > -		ret = sprintf(buf, "%#x\n", q->blk_trace->act_mask);
> > +		ret = blk_trace_mask2str(buf, q->blk_trace->act_mask);
> >  	else if (attr == &dev_attr_pid)
> >  		ret = sprintf(buf, "%u\n", q->blk_trace->pid);
> >  	else if (attr == &dev_attr_start_lba)
> > @@ -1432,9 +1456,11 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
> >  	if (attr == &dev_attr_act_mask) {
> >  		if (sscanf(buf, "%llx", &value) != 1) {
> >  			/* Assume it is a list of trace category names */
> > -			value = blk_str2act_mask(buf);
> > -			if (value < 0)
> > +			value = blk_trace_str2mask(buf);
> 
> Hmm, does this compile? Doesn't blk_trace_str2mask need two parameters?

No, it needs one parameter.

	Ingo
