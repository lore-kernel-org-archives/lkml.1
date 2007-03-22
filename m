Return-Path: <linux-kernel-owner+w=401wt.eu-S932645AbXCVEvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbXCVEvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 00:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXCVEvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 00:51:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36139 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932645AbXCVEvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 00:51:32 -0400
Date: Thu, 22 Mar 2007 15:51:06 +1100
From: David Chinner <dgc@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: nigel@nigel.suspend2.net, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       David Chinner <dgc@sgi.com>
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Message-ID: <20070322045106.GP32602149@melbourne.sgi.com>
References: <200703211840.53242.maximlevitsky@gmail.com> <1174512160.6665.97.camel@nigel.suspend2.net> <200703212238.33897.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703212238.33897.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 10:38:33PM +0100, Rafael J. Wysocki wrote:
> 
> I think this is the XFS problem with freezable workqueues.
> 
> Maxim, please try to apply the appended patch and see if it helps.
> 
> Greetings,
> Rafael
> 
> 
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

Acked-by: Dave Chinner <dgc@sgi.com>

Rafael, it sounds like this really needs to go into the next -rc
kernel. Can you push it to Linus?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
