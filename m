Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYAWRHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYAWRHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYAWRHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:07:08 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:33801 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbYAWRHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:07:06 -0500
Subject: Re: [PATCH 01/20 -v5] printk - dont wakeup klogd with interrupts
	disabled
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080123160441.236562634@goodmis.org>
References: <20080123160236.969334052@goodmis.org>
	 <20080123160441.236562634@goodmis.org>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 09:06:18 -0800
Message-Id: <1201107978.13596.16.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 11:02 -0500, Steven Rostedt wrote:

> +	if (!irqs_disabled() && wake_klogd)
>  		wake_up_klogd();

This causes a regression .. When printk is called during an OOPS in
kernels without this change then the OOPS will get logged, since the
logging process (klogd) is woken to handle the messages.. If you apply
this change klogd doesn't wakeup, and hence doesn't log the oops.. So if
you remove the wakeup here you have to add it someplace else to maintain
the logging ..

(I'm not theorizing here, I have defects logged against this specific
piece of code..)

Daniel

