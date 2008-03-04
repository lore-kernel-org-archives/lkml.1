Return-Path: <linux-kernel-owner+w=401wt.eu-S933920AbYCDW51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920AbYCDW51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 17:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYCDW5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 17:57:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:28125 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437AbYCDW5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 17:57:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dkrjTgCdURx9UdQAgEik0m8RhKq7tCQTZrHVnlYR5XefOMKMnUx1DEQjvULp0GuZsVV5PJCfmDjXfvty8RpJQIHQ2PJNNW91/d3a7VurW8vPDW+35KemLVGYie5eyWR8wmf/VJPCJb4CnBIYtTZSk6cKfNSQ1FCzNEUbthcfy5s=
Message-ID: <47CDD3F9.7070801@gmail.com>
Date: Tue, 04 Mar 2008 23:58:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Russell King <rmk@arm.linux.org.uk>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [JANITOR-PATCH] rtc: switch to unlocked_ioctl
References: <1204664803.5698.27.camel@brick>
In-Reply-To: <1204664803.5698.27.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison napsal(a):
> Make the lock/unlock_kernel explicit.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/arm/common/rtctime.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/common/rtctime.c b/arch/arm/common/rtctime.c
> index f53bca4..2062f92 100644
> --- a/arch/arm/common/rtctime.c
> +++ b/arch/arm/common/rtctime.c
> @@ -173,8 +173,7 @@ static unsigned int rtc_poll(struct file *file, poll_table *wait)
>  	return data != 0 ? POLLIN | POLLRDNORM : 0;
>  }
>  
> -static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> -		     unsigned long arg)
> +static int rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)

long? I guess you need to get a cross-compiler...
