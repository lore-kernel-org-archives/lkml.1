Return-Path: <linux-kernel-owner+w=401wt.eu-S1423547AbXBPKKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423547AbXBPKKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423549AbXBPKKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:10:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38196 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423547AbXBPKKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:10:54 -0500
Date: Fri, 16 Feb 2007 02:09:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Christian Limpach" <Christian.Limpach@xensource.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Chris Wright" <chrisw@sous-sol.org>, "Andi Kleen" <ak@muc.de>,
       "Keir Fraser" <Keir.Fraser@cl.cam.ac.uk>,
       <xen-devel@lists.xensource.com>, "Ian Pratt" <Ian.Pratt@xensource.com>,
       <virtualization@lists.osdl.org>,
       "Steven Hand" <steven.hand@cl.cam.ac.uk>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and
 disableunsupported config options.
Message-Id: <20070216020947.03e1726e.akpm@linux-foundation.org>
In-Reply-To: <BBC437B5B077FF46935BA1D8C9A2172A01EBEBF4@exch2.ad.xensource.com>
References: <BBC437B5B077FF46935BA1D8C9A2172A01EBEBF4@exch2.ad.xensource.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 02:00:39 -0800 "Christian Limpach" <Christian.Limpach@xensource.com> wrote:

> Jeremy Fitzhardinge wrote:
> > Andrew Morton wrote:
> > > On Thu, 15 Feb 2007 22:14:45 -0800 Dan Hecht 
> > <dhecht@vmware.com> wrote:
> > >
> > >   
> > >>>  config PREEMPT
> > >>>  	bool "Preemptible Kernel (Low-Latency Desktop)"
> > >>> +	depends on !XEN
> > >>>  	help
> > >>>  	  This option reduces the latency of the kernel by making
> > >>>  	  all kernel code (that is not executing in a critical section)
> > >>>
> > >>>       
> > >
> > > Oh, so that's why it doesn't break when CONFIG_PREEMPT=y.  
> > In which case
> > > that preempt_disable() I spotted is wrong-and-unneeded.
> > >
> > > Why doesn't Xen work with preemption??
> > >   
> > 
> > I've forgotten the details.  Ian?  Keir?  Steven?  Maybe it 
> > can be done.
> 
> With CONFIG_PREEMPT, we can have preempted threads reference machine
> addresses across save/restore.  After restore, these machine addresses
> will be incorrect.
> 

It would help if you could define the terms "save/restore" and "machine
addresses".  One can guess, but there are probably subtleties here..

Are the places where the domU code references machine addresses splattered
all over the code?  If not, they can just be wrapped with
preempt_disable/preempt_enable?

