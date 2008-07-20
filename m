Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbYGTVuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbYGTVuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 17:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbYGTVuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 17:50:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:55195 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYGTVuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 17:50:07 -0400
Date: Sun, 20 Jul 2008 14:50:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Rene Herman <rene.herman@keyaccess.nl>,
       Simon Arlott <simon@fire.lp0.eu>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch 5/3] fastboot: sync the async execution before
 late_initcall and move level 6s (sync) first
Message-ID: <20080720145003.7c1b05cb@infradead.org>
In-Reply-To: <1216588499.6971.1.camel@dhcp32.mvista.com>
References: <20080720085924.122feb2b@infradead.org>
	<20080720090041.5924f5ff@infradead.org>
	<1216588499.6971.1.camel@dhcp32.mvista.com>
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

On Sun, 20 Jul 2008 14:14:59 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> On Sun, 2008-07-20 at 09:00 -0700, Arjan van de Ven wrote:
> > @@ -775,6 +776,11 @@ static void __init do_initcalls(void)
> >                 }
> >                 if (phase == 1 && call >= __async_initcall_end)
> >                         phase = 2;
> > +               if (phase == 2 && call >= __device_initcall_end) {
> > +                       phase = 3;
> > +                       /* make sure all async work is done before
> > level 7 */
> > +                       flush_workqueue(async_init_wq);
> > +               }
> >                 if (phase != 1)
> >                         do_one_initcall(*call);
> >         }
> 
> Did this impact the boot time improvements at all?

not much in my measurement; but on my system .. level 7 is mostly empty
so there's not much difference


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
