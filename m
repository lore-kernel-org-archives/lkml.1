Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZCYIMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZCYIMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbZCYILz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:11:55 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:19304 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbZCYILy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:11:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIqCyUlR927n/2dsb2JhbADTKweDbwY
Date: Wed, 25 Mar 2009 09:11:51 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: stoyboyker@gmail.com
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH 08/13] [watchdog] changed ioctls to unlocked
Message-ID: <20090325081151.GD27002@infomag.iguana.be>
References: <1237929168-15341-9-git-send-email-stoyboyker@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237929168-15341-9-git-send-email-stoyboyker@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stoyan,

> From: Stoyan Gaydarov <stoyboyker@gmail.com>
> 
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> ---
>  drivers/watchdog/riowd.c |   37 +++++++++++++++++++++++++++----------
>  1 files changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
> index 09cb183..44058c1 100644
> --- a/drivers/watchdog/riowd.c
> +++ b/drivers/watchdog/riowd.c
> @@ -86,9 +86,10 @@ static int riowd_release(struct inode *inode, struct file *filp)
>  	return 0;
>  }
>  
> -static int riowd_ioctl(struct inode *inode, struct file *filp,
> -		       unsigned int cmd, unsigned long arg)
> +static long riowd_ioctl(struct file *filp, unsigned int cmd,
> +		       unsigned long arg)
>  {
> +	lock_kernel();

NAK. See commit c2dc3084010a7996c34e84bea14ff5346af7abd7 in the linux-2.6-watchdog-next tree that allready fixes this (and that will go to Linus one of these days for inclusion).

Kind regards,
Wim.

