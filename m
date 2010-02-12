Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0BLHRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 02:17:55 -0500
Received: from smtp.nokia.com ([192.100.105.134]:19670 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab0BLHRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 02:17:54 -0500
Subject: Re: [PATCH v2] class: Free the class private data in class_release
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1265805169-31315-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1265801743-26079-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1265805169-31315-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 09:16:58 +0200
Message-ID: <1265959018.26471.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Feb 2010 07:17:41.0418 (UTC) FILETIME=[76CDE0A0:01CAABB3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 13:32 +0100, Laurent Pinchart wrote:
> Fix a memory leak by freeing the memory allocated in __class_register
> for the class private data.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/base/class.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/class.c b/drivers/base/class.c
> index 161746d..6e2c3b0 100644
> --- a/drivers/base/class.c
> +++ b/drivers/base/class.c
> @@ -59,6 +59,8 @@ static void class_release(struct kobject *kobj)
>  	else
>  		pr_debug("class '%s' does not have a release() function, "
>  			 "be careful\n", class->name);
> +
> +	kfree(cp);
>  }
>  
>  static struct sysfs_ops class_sysfs_ops = {

This looks like 2.6.33 material for me. CC-ing Andrew.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

