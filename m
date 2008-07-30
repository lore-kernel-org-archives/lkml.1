Return-Path: <linux-kernel-owner+w=401wt.eu-S1762249AbYG3PTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762249AbYG3PTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYG3PTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:19:01 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49874 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbYG3PS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:18:59 -0400
Subject: Re: [PATCH] Fix miscalculation of sg_io timeout in
	CDROM_SEND_PACKET handler.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tim Wright <timw@splhi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <488D17DE.5000801@splhi.com>
References: <488D17DE.5000801@splhi.com>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 10:18:53 -0500
Message-Id: <1217431134.3335.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-27 at 17:50 -0700, Tim Wright wrote:
> @@ -629,7 +629,7 @@ int scsi_cmd_ioctl(struct file *file, st
>                         hdr.sbp = cgc.sense;
>                         if (hdr.sbp)
>                                 hdr.mx_sb_len = sizeof(struct 
> request_sense);
> -                       hdr.timeout = cgc.timeout;
> +                       hdr.timeout = jiffies_to_msecs(cgc.timeout);
>                         hdr.cmdp = ((struct cdrom_generic_command 
> __user*) arg)->cmd;
>                         hdr.cmd_len = sizeof(cgc.cmd);

I'm afraid this patch is completely whitespace damaged:  the tabs have
all become spaces and the mailer has broken some of the lines.

Since it's a one liner, I can make the fix directly, but if you look at

Documentation/SubmittingPatches

It has some good advice about how to fix your email tool to prevent this
from happening in future.

James


