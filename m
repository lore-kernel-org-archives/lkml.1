Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZLYCnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZLYCnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 21:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZLYCnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 21:43:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbZLYCnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 21:43:04 -0500
Message-ID: <4B342768.8080603@redhat.com>
Date: Fri, 25 Dec 2009 10:46:00 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
       BuraphaLinux Server <buraphalinuxserver@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [Patch] console: limit the range of VGACON_SOFT_SCROLLBACK_SIZE
References: <20091225024340.4431.59297.sendpatchset@localhost.localdomain>
In-Reply-To: <20091225024340.4431.59297.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding some Cc's in the original thread. :)

Amerigo Wang wrote:
> BuraphaLinux reported that we will trigger a mm warning when
> we CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=65536, this is because
> mm cann't allocate so many pages. We should limit the range
> of CONFIG_VGACON_SOFT_SCROLLBACK_SIZE, don't give a user
> any chance to trigger that.
> 
> Reported-by: BuraphaLinux Server <buraphalinuxserver@gmail.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> 
> ---
> diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
> index fc7d9bb..8e8f18d 100644
> --- a/drivers/video/console/Kconfig
> +++ b/drivers/video/console/Kconfig
> @@ -37,6 +37,7 @@ config VGACON_SOFT_SCROLLBACK
>  config VGACON_SOFT_SCROLLBACK_SIZE
>         int "Scrollback Buffer Size (in KB)"
>         depends on VGACON_SOFT_SCROLLBACK
> +       range 1 1024
>         default "64"
>         help
>           Enter the amount of System RAM to allocate for the scrollback

