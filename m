Return-Path: <linux-kernel-owner+w=401wt.eu-S934611AbXHWWnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934611AbXHWWnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934320AbXHWWjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:39:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57710 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934311AbXHWWjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:39:06 -0400
Date: Fri, 24 Aug 2007 04:21:58 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] s390 appldata_base: Remove module_exit function and
 modular stuff
In-Reply-To: <1187866866.6599.6.camel@localhost>
Message-ID: <alpine.LFD.0.999.0708240419120.14807@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0708230706570.2049@enigma.security.iitk.ac.in
 >  <alpine.LFD.0.999.0708230746450.2049@enigma.security.iitk.ac.in>
 <1187866866.6599.6.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,


On Thu, 23 Aug 2007, Martin Schwidefsky wrote:

> On Thu, 2007-08-23 at 07:51 +0530, Satyam Sharma wrote: 
> > > BTW the __exit module_exit function appldata_exit() of this driver
> > > fails to unregister_hotcpu_notifier() the notifier_block that was
> > > registered by appldata_init() during module startup. This will lead
> > > to oops if hotplug notification comes after module has been unloaded.
> > > Let's fix this by unregistering the notifier appropriately (before
> > > appldata_offline_cpu()'ing the CPUs).
> > 
> > Heh, no wonder we never saw this oops before. This code can never be
> > built as a module! :-) But why does it define and implement an __exit
> > marked module_exit(appldata_exit) function in that case ?!
> 
> I has been a module once for debugging purposes That the module_exit
> function still exists is "historical". We can remove it since it is dead
> code.

Thanks, fair enough. Does this mean you're acking them -- I'd prefer both
the patches to be applied separately. Rationale: we should still fix the
appldata_exit() related oops _before_ removing it so that in future if
this needs to be made modular for debugging purpose again, just the
removal patch can be reverted, but the oops would still be fixed in the
commit before it.


Satyam
