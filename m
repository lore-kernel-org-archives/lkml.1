Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbZCXVZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbZCXVZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZCXVYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:24:51 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49674 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbZCXVYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:24:50 -0400
Subject: Re: [PATCH 06/13] [scsi] changed ioctls to unlocked
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: stoyboyker@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
In-Reply-To: <1237929168-15341-7-git-send-email-stoyboyker@gmail.com>
References: <1237929168-15341-7-git-send-email-stoyboyker@gmail.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 21:24:48 +0000
Message-Id: <1237929888.3308.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 16:12 -0500, stoyboyker@gmail.com wrote:
> From: Stoyan Gaydarov <stoyboyker@gmail.com>
> 
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> ---
>  drivers/scsi/osst.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
> index 0ea78d9..80e7e98 100644
> --- a/drivers/scsi/osst.c
> +++ b/drivers/scsi/osst.c
> @@ -4856,9 +4856,10 @@ static int os_scsi_tape_close(struct inode * inode, struct file * filp)
>  
> 
>  /* The ioctl command */
> -static int osst_ioctl(struct inode * inode,struct file * file,
> -	 unsigned int cmd_in, unsigned long arg)
> +static long osst_ioctl(struct file * file, unsigned int cmd_in,
> +	unsigned long arg)
>  {
> +	lock_kernel();

What necessitates the kernel locking?  When st was audited, it didn't
need it; since osst is in many ways a copy of st, I'm surprised it does.

James


