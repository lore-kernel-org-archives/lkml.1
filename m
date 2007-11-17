Return-Path: <linux-kernel-owner+w=401wt.eu-S1764960AbXKQSli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764960AbXKQSli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759504AbXKQSlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:41:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39387 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759269AbXKQSla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:41:30 -0500
Date: Sat, 17 Nov 2007 10:39:47 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de
Subject: Re: [patch] Printk kernel version in WARN_ON
Message-ID: <20071117103947.5b2052f8@laptopd505.fenrus.org>
In-Reply-To: <20071117102720.251107d7.akpm@linux-foundation.org>
References: <20071117101552.2a7f34cb@laptopd505.fenrus.org>
	<20071117102720.251107d7.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007 10:27:20 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 17 Nov 2007 10:15:52 -0800 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > @@ -35,8 +36,8 @@ struct bug_entry {
> >  #define WARN_ON(condition)
> > ({						\ int
> > __ret_warn_on = !!(condition);				\ if
> > (unlikely(__ret_warn_on)) {					\
> > -		printk("WARNING: at %s:%d %s()\n",
> > __FILE__,		\
> > -			__LINE__,
> > __FUNCTION__);			\
> > +		printk("WARNING: at %s:%d %s()  (%s)\n",
> > __FILE__,	\
> > +			__LINE__, __FUNCTION__,
> > UTS_RELEASE);		\
> > dump_stack();
> > \ }
> > \ unlikely(__ret_warn_on);					\
> 
> that made our 1100-odd WARN_ON sites fatter.

by ... not too much at least, gcc ought to be quite good at merging
same-strings into one, so it's just one extra pointer argument



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
