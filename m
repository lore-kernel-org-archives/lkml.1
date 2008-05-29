Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbYE2Hmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbYE2Hmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 03:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYE2HmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 03:42:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbYE2HmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 03:42:23 -0400
Date: Thu, 29 May 2008 00:41:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerry Stralko <gerb.stralko@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: remove CDROM not ready printk
Message-Id: <20080529004154.bbc7b1d4.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805271502370.3985@localhost.localdomain>
References: <alpine.LFD.1.10.0805271502370.3985@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 15:02:43 -0400 (EDT) Jerry Stralko <gerb.stralko@gmail.com> wrote:

> Hello,

let's cc a scsi list which exists ;)

>    This printk was spamming my dmesg and /var/log/message.  Is there a 
> reason we have this printk?  Can we simply remove it?
> 
> 
> Signed-off-by: Jerry Stralko <gerb.stralko@gmail.com>
> ---
> 
> 
> diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
> index ae87d08..c37fb1c 100644
> --- a/drivers/scsi/sr_ioctl.c
> +++ b/drivers/scsi/sr_ioctl.c
> @@ -238,8 +238,6 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
>   					break;
>   				}
>   			}
> -			if (!cgc->quiet)
> -				printk(KERN_INFO "%s: CDROM not ready.  Make sure there is a disc in the drive.\n", cd->cdi.name);
>   #ifdef DEBUG
>   			scsi_print_sense_hdr("sr", &sshdr);
>   #endif

The answer may be that you need to enable cgc->quiet.  If that is
user-enableable - I can't work out how from a quick grep.

