Return-Path: <linux-kernel-owner+w=401wt.eu-S1751900AbXBPK1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbXBPK1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbXBPK1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:27:34 -0500
Received: from 207.47.60.150.static.nextweb.net ([207.47.60.150]:17935 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbXBPK1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:27:33 -0500
X-Greylist: delayed 1490 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Feb 2007 05:27:33 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 14/21] Xen-paravirt: Add XEN config options and disableunsupported config options.
Date: Fri, 16 Feb 2007 02:00:39 -0800
Message-ID: <BBC437B5B077FF46935BA1D8C9A2172A01EBEBF4@exch2.ad.xensource.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [patch 14/21] Xen-paravirt: Add XEN config options and disableunsupported config options.
Thread-Index: AcdRnIFegKnbAY+pRYux0pTDKlRLwQAFFnNg
From: "Christian Limpach" <Christian.Limpach@xensource.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Chris Wright" <chrisw@sous-sol.org>, "Andi Kleen" <ak@muc.de>,
       "Keir Fraser" <Keir.Fraser@cl.cam.ac.uk>,
       <xen-devel@lists.xensource.com>, "Ian Pratt" <Ian.Pratt@xensource.com>,
       <virtualization@lists.osdl.org>,
       "Steven Hand" <steven.hand@cl.cam.ac.uk>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Andrew Morton wrote:
> > On Thu, 15 Feb 2007 22:14:45 -0800 Dan Hecht 
> <dhecht@vmware.com> wrote:
> >
> >   
> >>>  config PREEMPT
> >>>  	bool "Preemptible Kernel (Low-Latency Desktop)"
> >>> +	depends on !XEN
> >>>  	help
> >>>  	  This option reduces the latency of the kernel by making
> >>>  	  all kernel code (that is not executing in a critical section)
> >>>
> >>>       
> >
> > Oh, so that's why it doesn't break when CONFIG_PREEMPT=y.  
> In which case
> > that preempt_disable() I spotted is wrong-and-unneeded.
> >
> > Why doesn't Xen work with preemption??
> >   
> 
> I've forgotten the details.  Ian?  Keir?  Steven?  Maybe it 
> can be done.

With CONFIG_PREEMPT, we can have preempted threads reference machine
addresses across save/restore.  After restore, these machine addresses
will be incorrect.

    Christian
