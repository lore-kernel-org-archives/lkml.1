Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbZKMWW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbZKMWW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbZKMWWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:22:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756272AbZKMWWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:22:53 -0500
Date: Fri, 13 Nov 2009 14:22:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Sujith Thomas <sujith.thomas@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/thermal/thermal_sys.c: fix strncmp tests
Message-Id: <20091113142254.73f82283.akpm@linux-foundation.org>
In-Reply-To: <1257804769.12852.22.camel@Joe-Laptop.home>
References: <1257804769.12852.22.camel@Joe-Laptop.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Nov 2009 14:12:49 -0800
Joe Perches <joe@perches.com> wrote:

> Use strncmp(var, "foo", sizeof("foo") - 1)
> not strncmp(var, "foo", sizeof("foo"))
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 4e83c29..c35d538 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -147,9 +147,9 @@ mode_store(struct device *dev, struct device_attribute *attr,
>  	if (!tz->ops->set_mode)
>  		return -EPERM;
>  
> -	if (!strncmp(buf, "enabled", sizeof("enabled")))
> +	if (!strncmp(buf, "enabled", sizeof("enabled") - 1))

How about

	if (!strcmp(buf, "enabled"))

?
