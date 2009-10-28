Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbZJ1WE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbZJ1WE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZJ1WE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:04:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46215 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZJ1WE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:04:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Dasgupta, Romit" <romit@ti.com>
Subject: Re: [linux-pm] [PATCH] PM: Fixes warning on suspend errors
Date: Wed, 28 Oct 2009 23:06:34 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, "Hilman, Kevin" <khilman@ti.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <B85A65D85D7EB246BE421B3FB0FBB59301DE0DC96A@dbde02.ent.ti.com> <Pine.LNX.4.44L0.0910270936450.2882-100000@iolanthe.rowland.org> <B85A65D85D7EB246BE421B3FB0FBB59301DE0DCA79@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301DE0DCA79@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910282306.34431.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 October 2009, Dasgupta, Romit wrote:
> Ok. Then the following is the refined and probably more appropriate one.
> 
> 
> 
> This fixes the point where we need to complete the power transition when 
> device suspend fails.
> 
> Signed-off-by: Romit Dasgupta <romit@ti.com>
> ---
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index e0dc407..3d0b26a 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -444,6 +444,7 @@ static void dpm_resume(pm_message_t state)
>  
>  	INIT_LIST_HEAD(&list);
>  	mutex_lock(&dpm_list_mtx);
> +	transition_started = false;
>  	while (!list_empty(&dpm_list)) {
>  		struct device *dev = to_device(dpm_list.next);
> 

Applied to suspend-2.6/linux-next.

Thanks,
Rafael
