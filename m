Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYAWReU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYAWReU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbYAWRaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:30:15 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:34517 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756703AbYAWRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:30:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAM8Hl0dMQWYq/2dsb2JhbACBV6xh
Date: Wed, 23 Jan 2008 12:25:09 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Daniel Walker <dwalker@mvista.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/20 -v5] printk - dont wakeup klogd with interrupts
	disabled
Message-ID: <20080123172509.GC22229@Krystal>
References: <20080123160236.969334052@goodmis.org> <20080123160441.236562634@goodmis.org> <1201107978.13596.16.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1201107978.13596.16.camel@imap.mvista.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:22:25 up 80 days, 22:27,  5 users,  load average: 0.96, 0.67,
	0.46
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Walker (dwalker@mvista.com) wrote:
> 
> On Wed, 2008-01-23 at 11:02 -0500, Steven Rostedt wrote:
> 
> > +	if (!irqs_disabled() && wake_klogd)
> >  		wake_up_klogd();
> 
> This causes a regression .. When printk is called during an OOPS in
> kernels without this change then the OOPS will get logged, since the
> logging process (klogd) is woken to handle the messages.. If you apply
> this change klogd doesn't wakeup, and hence doesn't log the oops.. So if
> you remove the wakeup here you have to add it someplace else to maintain
> the logging ..
> 
> (I'm not theorizing here, I have defects logged against this specific
> piece of code..)
> 

Can we change this for :
if (!(irqs_disabled() && !oops_in_progress) && wake_klogd)
  wake_up_klogd();

?

(totally untested)

> Daniel
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
