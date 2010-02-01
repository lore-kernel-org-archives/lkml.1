Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab0BARpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:45:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:50065 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab0BARpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:45:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bk7b6FDjQYwK6vV4umKS8bwGIhhs0eiCCt5l6DHFIVLWmNPXV2HBWePGlvUjfEMnyn
         a46Kg4FdQogdxebnejHEnDsRAUQuNe9uU/WQlmq4MBSwl5Id5Ln8W8KzUgGcsOh1//AF
         8upSzUrhhKcdFtXDYyXI2r8rhTge9HlE7qTLA=
Date: Mon, 1 Feb 2010 18:45:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.in.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin <schwidefsky@de.ibm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Subject: Re: [patch] HWBKPT: Make bp_len type to u64 generic across the arch
Message-ID: <20100201174459.GA5241@nowhere>
References: <20100130045424.625452081@mars.in.ibm.com> <20100130045518.GA20776@in.ibm.com> <20100130183835.GA5675@nowhere> <1265012584.24455.78.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265012584.24455.78.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 09:23:04AM +0100, Peter Zijlstra wrote:
> On Sat, 2010-01-30 at 19:38 +0100, Frederic Weisbecker wrote:
> > > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > > index 1438463..30c78bd 100644
> > > --- a/include/linux/perf_event.h
> > > +++ b/include/linux/perf_event.h
> > > @@ -211,11 +211,9 @@ struct perf_event_attr {
> > >               __u32           wakeup_watermark; /* bytes before wakeup   */
> > >       };
> > >  
> > > -     __u32                   __reserved_2;
> > > -
> > > -     __u64                   bp_addr;
> > >       __u32                   bp_type;
> > > -     __u32                   bp_len;
> > > +     __u64                   bp_addr;
> > > +     __u64                   bp_len;
> > >  };
> > 
> > 
> > 
> > Peter, what do you think about this new layout?
> > Putting the bp_type right after the wakeup_* fields
> > is going to remove the padding difference between
> > 64 and 32 archs. That looks better than the __reserved_2
> > we had.
> 
> Right, I think this works nicely in that all elements will be naturally
> aligned and not result in different layouts between 32/64 bit builds.
> 
> > If this patch can make it for .33, it would be nice.
> 
> It has to make .33, if it doesn't you're hosed because then the old
> layout is fixed in stone.
> 


Truly.
I'll send a pull request to Ingo quickly then.

Thanks.

