Return-Path: <linux-kernel-owner+w=401wt.eu-S965596AbXBILA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965596AbXBILA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965728AbXBILA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:00:58 -0500
Received: from ozlabs.org ([203.10.76.45]:41616 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965745AbXBILA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:00:57 -0500
Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>, virtualization <virtualization@lists.osdl.org>,
       Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20070209013518.e75d5036.akpm@linux-foundation.org>
References: <1171012296.2718.26.camel@localhost.localdomain>
	 <1171012458.2718.30.camel@localhost.localdomain>
	 <1171012693.2718.37.camel@localhost.localdomain>
	 <1171012761.2718.40.camel@localhost.localdomain>
	 <1171012827.2718.42.camel@localhost.localdomain>
	 <20070209013518.e75d5036.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 22:00:12 +1100
Message-Id: <1171018812.2718.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 01:35 -0800, Andrew Morton wrote:
> On Fri, 09 Feb 2007 20:20:27 +1100 Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > +#define log(...)					\
> > +	do {						\
> > +		mm_segment_t oldfs = get_fs();		\
> > +		char buf[100];				\
> > +		sprintf(buf, "lguest:" __VA_ARGS__);	\
> > +		set_fs(KERNEL_DS);			\
> > +		sys_write(1, buf, strlen(buf));		\
> > +		set_fs(oldfs);				\
> > +	} while(0)
> 
> Due to gcc shortcomings, each instance of this will chew an additional 100
> bytes of stack.  Unless they fixed it recently.  Is a bit of a timebomb.  I
> guess ksaprintf() could be used.
> 
> It also looks a bit, umm, innovative.

It's also unused 8)

It's an extremely useful macro for doing grossly invasive logging of the
guest.  I'll drop it if you prefer.

Cheers,
Rusty.

