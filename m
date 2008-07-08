Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYGHWtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYGHWtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYGHWtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:49:24 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:19432 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbYGHWtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:49:24 -0400
Date: Tue, 8 Jul 2008 15:48:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, rjw@sisk.pl,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] xen: new power management driver calls
Message-Id: <20080708154833.394edff9.randy.dunlap@oracle.com>
In-Reply-To: <4873CB82.70002@goop.org>
References: <20080708201327.GA11888@vespa.holoscopio.com>
	<4873CB82.70002@goop.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jul 2008 13:18:10 -0700 Jeremy Fitzhardinge wrote:

> Thadeu Lima de Souza Cascardo wrote:
> > linux-next won't build with CONFIG_XEN and CONFIG_PM_SLEEP because
> > xen_suspend calls device_power_up and device_resume, which require a
> > parameter since commit 1eede070a59e1cc73da51e1aaa00d9ab86572cfc.
> >   
> 
> Someone (Randy?) reported this before, but then I quietly forgot all 
> about it.  Thanks for the patch.
> 
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.


>     J
> 
> > ---
> >  drivers/xen/manage.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> > index 5b546e3..64c554e 100644
> > --- a/drivers/xen/manage.c
> > +++ b/drivers/xen/manage.c
> > @@ -63,7 +63,7 @@ static int xen_suspend(void *data)
> >  	gnttab_resume();
> >  	xen_mm_unpin_all();
> >  
> > -	device_power_up();
> > +	device_power_up(PMSG_RESUME);
> >  
> >  	if (!*cancelled) {
> >  		xen_irq_resume();
> > @@ -112,7 +112,7 @@ static void do_suspend(void)
> >  	else
> >  		xenbus_suspend_cancel();
> >  
> > -	device_resume();
> > +	device_resume(PMSG_RESUME);
> >  
> >  	/* Make sure timer events get retriggered on all CPUs */
> >  	clock_was_set();
> >   


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
