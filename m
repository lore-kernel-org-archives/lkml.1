Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbXFNQAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbXFNQAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXFNQAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:00:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:58825 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbXFNQAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:00:13 -0400
Date: Thu, 14 Jun 2007 08:59:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com, iss_storagedev@hp.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] cciss: force ignore of responses to unsent scsi
 commands after kexec reboot
Message-Id: <20070614085924.258f9426.randy.dunlap@oracle.com>
In-Reply-To: <20070614153119.GC32137@hmsreliant.homelinux.net>
References: <20070614153119.GC32137@hmsreliant.homelinux.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007 11:31:19 -0400 Neil Horman wrote:

> Hey -
> 	cciss hardware currently can continue to send responses to scsi commands
> after the host system has undergone a kexec reboot.  The way the drier is
> currently written, reception of these commands results in a BUG halt, since it
> can't match the response to any issued command since the boot.  This patch
> corrects that by using the kexec reset_devices command line paramter to force
> ignore any commands that it cant correlate.
> 
> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
>  cciss.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 5acc6c4..ec1c1d2 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -2131,6 +2131,14 @@ static int add_sendcmd_reject(__u8 cmd, int ctlr, unsigned long complete)
>  		       ctlr, complete);
>  		/* not much we can do. */
>  #ifdef CONFIG_CISS_SCSI_TAPE
> +		/* We might get notification of completion of commands
> +		 * which we never issued in this kernel if this boot is
> +		 * taking place after previous kernel's crash. Simply
> +		 * ignore the commands in this case.
> +		 */
> +		if (reset_devices)
> +			return 0;
> +
>  		return 1;
>  	}

But this patch applies only to SCSI tape devices, not to
disk devices?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
