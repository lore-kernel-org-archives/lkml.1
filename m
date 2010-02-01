Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab0BAIXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 03:23:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab0BAIXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 03:23:18 -0500
Subject: Re: [patch] HWBKPT: Make bp_len type to u64 generic across the arch
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.in.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin <schwidefsky@de.ibm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
In-Reply-To: <20100130183835.GA5675@nowhere>
References: <20100130045424.625452081@mars.in.ibm.com>
	 <20100130045518.GA20776@in.ibm.com>  <20100130183835.GA5675@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 09:23:04 +0100
Message-ID: <1265012584.24455.78.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-30 at 19:38 +0100, Frederic Weisbecker wrote:
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index 1438463..30c78bd 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -211,11 +211,9 @@ struct perf_event_attr {
> >               __u32           wakeup_watermark; /* bytes before wakeup   */
> >       };
> >  
> > -     __u32                   __reserved_2;
> > -
> > -     __u64                   bp_addr;
> >       __u32                   bp_type;
> > -     __u32                   bp_len;
> > +     __u64                   bp_addr;
> > +     __u64                   bp_len;
> >  };
> 
> 
> 
> Peter, what do you think about this new layout?
> Putting the bp_type right after the wakeup_* fields
> is going to remove the padding difference between
> 64 and 32 archs. That looks better than the __reserved_2
> we had.

Right, I think this works nicely in that all elements will be naturally
aligned and not result in different layouts between 32/64 bit builds.

> If this patch can make it for .33, it would be nice.

It has to make .33, if it doesn't you're hosed because then the old
layout is fixed in stone.

