Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbXFMHHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbXFMHHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 03:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXFMHH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 03:07:29 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49919 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754306AbXFMHH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 03:07:28 -0400
Message-ID: <381718439.10870@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 13 Jun 2007 15:07:25 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 5/9] readahead: on-demand readahead logic
Message-ID: <20070613070724.GA6146@mail.ustc.edu.cn>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>,
	Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>
References: <20070516224752.500812933@mail.ustc.edu.cn> <20070516224818.841068730@mail.ustc.edu.cn> <1181622986.6237.65.camel@localhost.localdomain> <20070612103518.GA9624@mail.ustc.edu.cn> <1181698833.6237.113.camel@localhost.localdomain> <20070613040044.GB6494@mail.ustc.edu.cn> <1181713875.6237.134.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181713875.6237.134.camel@localhost.localdomain>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 03:51:14PM +1000, Rusty Russell wrote:
> > >  static unsigned long
> > >  ondemand_readahead(struct address_space *mapping,
> > >  		   struct file_ra_state *ra, struct file *filp,
> > > -		   struct page *page, pgoff_t offset,
> > > +		   bool hit_lookahead_marker, pgoff_t offset,
> > 
> > Or use names like async/is_async for hit_lookahead_marker?
> 
> I wasn't sure.  The argument says "we've hit a marker, so do readahead
> even if doesn't look sequential.".  Now, you and I know that only
> happens if it's an async readahead, but that's not really relevant to
> this function.

Yeah, it's an interface for the message "hey I hit a readahead marker".
That's the point!

> OK, here is revised patch with your changes:
> 
> ====
> Split ondemand readahead interface into two functions.  I think this
> makes it a little clearer for non-readahead experts (like Rusty).
> 
> Internally they both call ondemand_readahead(), but the page argument
> is changed to an obvious boolean flag.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

Thank you,
Fengguang

