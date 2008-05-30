Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbYE3AQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbYE3AQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 20:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYE3AQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 20:16:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62229 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865AbYE3AQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 20:16:06 -0400
Date: Thu, 29 May 2008 17:24:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xen: fix compilation when CONFIG_PM_SLEEP is disabled
Message-Id: <20080529172436.70598587.randy.dunlap@oracle.com>
In-Reply-To: <483E630B.5090006@goop.org>
References: <patchbomb.1211550067@localhost>
	<9e8d06e5ae8024829836.1211550077@localhost>
	<20080529073150.GA19744@elte.hu>
	<483E630B.5090006@goop.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

On Thu, 29 May 2008 09:02:19 +0100 Jeremy Fitzhardinge wrote:

> Xen save/restore depends on CONFIG_PM_SLEEP being set for device_power_up/down.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>

Ack.  Thanks.

> ---
>  drivers/xen/manage.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> ===================================================================
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -31,6 +31,7 @@
>  /* Ignore multiple shutdown requests. */
>  static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
>  
> +#ifdef CONFIG_PM_SLEEP
>  static int xen_suspend(void *data)
>  {
>  	int *cancelled = data;
> @@ -121,6 +122,7 @@
>  #endif
>  	shutting_down = SHUTDOWN_INVALID;
>  }
> +#endif	/* CONFIG_PM_SLEEP */
>  
>  static void shutdown_handler(struct xenbus_watch *watch,
>  			     const char **vec, unsigned int len)


---
~Randy
"He closes his eyes and drops the goggles.  You can't get hurt
by looking at a bitmap.  Or can you?"
