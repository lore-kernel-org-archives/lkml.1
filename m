Return-Path: <linux-kernel-owner+w=401wt.eu-S934017AbXCUXrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017AbXCUXrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934060AbXCUXrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:47:08 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:43773 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934017AbXCUXrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:47:06 -0400
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, David Chinner <dgc@sgi.com>
In-Reply-To: <200703212238.33897.rjw@sisk.pl>
References: <200703211840.53242.maximlevitsky@gmail.com>
	 <1174512160.6665.97.camel@nigel.suspend2.net>
	 <200703212238.33897.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 10:47:05 +1100
Message-Id: <1174520825.6665.105.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2007-03-21 at 22:38 +0100, Rafael J. Wysocki wrote:
> > Do you know exactly which mutex was being waited on and where it was
> > taken? If you can say that, it would be much more helpful.

Yeah, me too, but assuming too much sometimes bites me :)

> I think this is the XFS problem with freezable workqueues.
> 
> Maxim, please try to apply the appended patch and see if it helps.

Thanks for your subsequent messages, Maxim. Could you confirm for us
that the patch Rafael attached fixes it?

Regards,

Nigel

> ---
> Since freezable workqueues are broken in 2.6.21-rc
> (cf. http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755,
> http://marc.theaimsgroup.com/?l=linux-kernel&m=117261312523921&w=2)
> it's better to remove them altogether for 2.6.21 and change the only user of
> them (XFS) accordingly.
> 
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.21-rc4/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6.21-rc4.orig/fs/xfs/linux-2.6/xfs_buf.c
> +++ linux-2.6.21-rc4/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1829,11 +1829,11 @@ xfs_buf_init(void)
>  	if (!xfs_buf_zone)
>  		goto out_free_trace_buf;
>  
> -	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
> +	xfslogd_workqueue = create_workqueue("xfslogd");
>  	if (!xfslogd_workqueue)
>  		goto out_free_buf_zone;
>  
> -	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
> +	xfsdatad_workqueue = create_workqueue("xfsdatad");
>  	if (!xfsdatad_workqueue)
>  		goto out_destroy_xfslogd_workqueue;
>  

