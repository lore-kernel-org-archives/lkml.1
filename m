Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbXCRAql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbXCRAql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 20:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbXCRAql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 20:46:41 -0400
Received: from ozlabs.org ([203.10.76.45]:32899 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbXCRAqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 20:46:40 -0400
Subject: Re: [PATCH RESEND 2/2] Fix some kallsyms_lookup() vs rmmod races
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, devel@openvz.org, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, pmarques@grupopie.com
In-Reply-To: <20070316115154.GC30195@elte.hu>
References: <20070316114458.GB6817@localhost.sw.ru>
	 <20070316115154.GC30195@elte.hu>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 20:37:18 +1100
Message-Id: <1174124239.8897.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 12:51 +0100, Ingo Molnar wrote:
> * Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> > [cc'ing folks whose proc files are affected]
> > 
> > kallsyms_lookup() can call module_address_lookup() which iterates over 
> > modules list without module_mutex taken. Comment at the top of 
> > module_address_lookup() says it's for oops resolution so races are 
> > irrelevant, but in some cases it's reachable from regular code:
> 
> looking at the problem from another angle: wouldnt this be something 
> that would benefit from freeze_processes()/unfreeze_processes(), and 
> hence no locking would be required?

Actually, the list manipulation is done with stop_machine for this
reason. Alexey, is preempt enabled in your kernel?

Rusty.


