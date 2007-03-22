Return-Path: <linux-kernel-owner+w=401wt.eu-S964989AbXCVIP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbXCVIP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965850AbXCVIP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:15:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33598 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964989AbXCVIO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:14:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Date: Thu, 22 Mar 2007 09:17:51 +0100
User-Agent: KMail/1.9.5
Cc: David Chinner <dgc@sgi.com>, nigel@nigel.suspend2.net,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <200703211840.53242.maximlevitsky@gmail.com> <200703220823.41077.rjw@sisk.pl> <20070321233159.0f851bdd.akpm@linux-foundation.org>
In-Reply-To: <20070321233159.0f851bdd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703220917.52500.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 March 2007 08:31, Andrew Morton wrote:
> On Thu, 22 Mar 2007 08:23:39 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Thursday, 22 March 2007 05:51, David Chinner wrote:
> > > On Wed, Mar 21, 2007 at 10:38:33PM +0100, Rafael J. Wysocki wrote:
> > > > 
> > > > I think this is the XFS problem with freezable workqueues.
> > > > 
> > > > Maxim, please try to apply the appended patch and see if it helps.
> > > > 
> > > > Greetings,
> > > > Rafael
> > > > 
> > > > 
> > > > ---
> > > > Since freezable workqueues are broken in 2.6.21-rc
> > > > (cf. http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755,
> > > > http://marc.theaimsgroup.com/?l=linux-kernel&m=117261312523921&w=2)
> > > > it's better to remove them altogether for 2.6.21 and change the only user of
> > > > them (XFS) accordingly.
> > > > 
> > > > ---
> > > >  fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > Index: linux-2.6.21-rc4/fs/xfs/linux-2.6/xfs_buf.c
> > > > ===================================================================
> > > > --- linux-2.6.21-rc4.orig/fs/xfs/linux-2.6/xfs_buf.c
> > > > +++ linux-2.6.21-rc4/fs/xfs/linux-2.6/xfs_buf.c
> > > > @@ -1829,11 +1829,11 @@ xfs_buf_init(void)
> > > >  	if (!xfs_buf_zone)
> > > >  		goto out_free_trace_buf;
> > > >  
> > > > -	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
> > > > +	xfslogd_workqueue = create_workqueue("xfslogd");
> > > >  	if (!xfslogd_workqueue)
> > > >  		goto out_free_buf_zone;
> > > >  
> > > > -	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
> > > > +	xfsdatad_workqueue = create_workqueue("xfsdatad");
> > > >  	if (!xfsdatad_workqueue)
> > > >  		goto out_destroy_xfslogd_workqueue;
> > > >  
> > > 
> > > Acked-by: Dave Chinner <dgc@sgi.com>
> > > 
> > > Rafael, it sounds like this really needs to go into the next -rc
> > > kernel. Can you push it to Linus?
> > 
> > I tried, but Andrew resent it to you. :-)
> > 
> > Andrew, could we please merge it?
> 
> Sure.
> 
> It shouldn't be this hard :(

Thanks!
