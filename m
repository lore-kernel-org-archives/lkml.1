Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYGSDoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYGSDoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 23:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYGSDoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 23:44:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:51918 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYGSDoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 23:44:08 -0400
Date: Fri, 18 Jul 2008 20:44:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 1/3] fastboot: Create a "asynchronous" initlevel
Message-ID: <20080718204406.7426e8fe@infradead.org>
In-Reply-To: <1216430540.3978.137.camel@localhost.localdomain>
References: <20080718151524.5ef9e29b@infradead.org>
	<20080718151608.46dc17c0@infradead.org>
	<1216430540.3978.137.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 18:22:20 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> On Fri, 2008-07-18 at 15:16 -0700, Arjan van de Ven wrote:
> > +static void __init do_initcalls(void)
> > +{
> > +       initcall_t *call;
> > +       static DECLARE_WORK(async_work, do_async_initcalls);
> > +       int phase = 0; /* 0 = levels 0 - 6, 1 = level 6a, 2 = after
> > level 6a */
> > +
> > +       async_init_wq = create_singlethread_workqueue("kasyncinit");
> > +
> 
> Could you spawning one thread per cpu, and queuing the work evenly?

not without loosing the ordering.....



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
