Return-Path: <linux-kernel-owner+w=401wt.eu-S1030197AbXCVHci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197AbXCVHci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030196AbXCVHci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:32:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42689 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030197AbXCVHcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:32:36 -0400
Date: Wed, 21 Mar 2007 23:31:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Chinner <dgc@sgi.com>, nigel@nigel.suspend2.net,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Message-Id: <20070321233159.0f851bdd.akpm@linux-foundation.org>
In-Reply-To: <200703220823.41077.rjw@sisk.pl>
References: <200703211840.53242.maximlevitsky@gmail.com>
	<200703212238.33897.rjw@sisk.pl>
	<20070322045106.GP32602149@melbourne.sgi.com>
	<200703220823.41077.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 08:23:39 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday, 22 March 2007 05:51, David Chinner wrote:
> > On Wed, Mar 21, 2007 at 10:38:33PM +0100, Rafael J. Wysocki wrote:
> > > 
> > > I think this is the XFS problem with freezable workqueues.
> > > 
> > > Maxim, please try to apply the appended patch and see if it helps.
> > > 
> > > Greetings,
> > > Rafael
> > > 
> > > 
> > > ---
> > > Since freezable workqueues are broken in 2.6.21-rc
> > > (cf. http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755,
> > > http://marc.theaimsgroup.com/?l=linux-kernel&m=117261312523921&w=2)
> > > it's better to remove them altogether for 2.6.21 and change the only user of
> > > them (XFS) accordingly.
> > > 
> > > ---
> > >  fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > Index: linux-2.6.21-rc4/fs/xfs/linux-2.6/xfs_buf.c
> > > ===================================================================
> > > --- linux-2.6.21-rc4.orig/fs/xfs/linux-2.6/xfs_buf.c
> > > +++ linux-2.6.21-rc4/fs/xfs/linux-2.6/xfs_buf.c
> > > @@ -1829,11 +1829,11 @@ xfs_buf_init(void)
> > >  	if (!xfs_buf_zone)
> > >  		goto out_free_trace_buf;
> > >  
> > > -	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
> > > +	xfslogd_workqueue = create_workqueue("xfslogd");
> > >  	if (!xfslogd_workqueue)
> > >  		goto out_free_buf_zone;
> > >  
> > > -	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
> > > +	xfsdatad_workqueue = create_workqueue("xfsdatad");
> > >  	if (!xfsdatad_workqueue)
> > >  		goto out_destroy_xfslogd_workqueue;
> > >  
> > 
> > Acked-by: Dave Chinner <dgc@sgi.com>
> > 
> > Rafael, it sounds like this really needs to go into the next -rc
> > kernel. Can you push it to Linus?
> 
> I tried, but Andrew resent it to you. :-)
> 
> Andrew, could we please merge it?

Sure.

It shouldn't be this hard :(
