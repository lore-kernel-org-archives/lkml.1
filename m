Return-Path: <linux-kernel-owner+w=401wt.eu-S940242AbXGaA2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940242AbXGaA2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936407AbXGaA2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:28:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33394 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbXGaA2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:28:01 -0400
Date: Tue, 31 Jul 2007 06:10:21 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>, Matt Mackall <mpm@selenic.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3 -mm 9/9] netconsole: Support dynamic reconfiguration
 using configfs
In-Reply-To: <20070730171306.49b49818.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707310603570.17287@enigma.security.iitk.ac.in>
References: <20070730024741.10828.48209.sendpatchset@enigma.security.iitk.ac.in>
 <20070730024910.10828.44721.sendpatchset@enigma.security.iitk.ac.in>
 <20070730171306.49b49818.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, Andrew Morton wrote:

> On Mon, 30 Jul 2007 08:19:10 +0530
> Satyam Sharma <satyam@infradead.org> wrote:
> 
> > +/*
> > + * Wrapper over simple_strtol (base 10) with sanity and range checking.
> > + * We return (signed) long only because we may want to return errors.
> > + * Do not use this to convert numbers that are allowed to be negative.
> > + */
> > +static long strtol10_check_range(const char *cp, long min, long max)
> > +{
> > +	long ret;
> > +	char *p = (char *) cp;
> > +
> > +	WARN_ON(min < 0);
> > +	WARN_ON(max < min);
> > +
> > +	ret = simple_strtol(p, &p, 10);
> > +
> > +	if (*p && (*p != '\n')) {
> > +		printk(KERN_ERR "netconsole: invalid input\n");
> > +		return -EINVAL;
> > +	}
> > +	if ((ret < min) || (ret > max)) {
> > +		printk(KERN_ERR "netconsole: input %ld must be between "
> > +				"%ld and %ld\n", ret, min, max);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return ret;
> > +}
> 
> There's probably other code around the place which does this.  It might
> be worth making this function a general-purpose thing.

Probably, yes, I thought along similar lines.

[ BTW somewhere in the 9/9 patch I remember having to define a
  __U16_MAX as well. That could be pushed out to some generic
  or appropriate header as well, possibly. ]


Satyam
