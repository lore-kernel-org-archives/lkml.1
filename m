Return-Path: <linux-kernel-owner+w=401wt.eu-S1764024AbZAPAKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764024AbZAPAKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZAPAKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:10:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680AbZAPAKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:10:38 -0500
Date: Thu, 15 Jan 2009 16:10:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2.6.29-rc] regulator: minor cleanup of virtual consumer
Message-Id: <20090115161022.2b11ed41.akpm@linux-foundation.org>
In-Reply-To: <200901141316.27584.david-b@pacbell.net>
References: <200901141316.27584.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 13:16:27 -0800
David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Minor cleanup to the regulator set_mode sysfs support:
> switch to sysfs_streq() in set_mode(), which is also
> a code shrink.  Use the same strings that get_mode()
> uses, shrinking data too.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/regulator/virtual.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/drivers/regulator/virtual.c
> +++ b/drivers/regulator/virtual.c
> @@ -226,13 +226,13 @@ static ssize_t set_mode(struct device *d
>  	unsigned int mode;
>  	int ret;
>  
> -	if (strncmp(buf, "fast", strlen("fast")) == 0)
> +	if (sysfs_streq(buf, "fast\n") == 0)
>  		mode = REGULATOR_MODE_FAST;
> -	else if (strncmp(buf, "normal", strlen("normal")) == 0)
> +	else if (sysfs_streq(buf, "normal\n") == 0)
>  		mode = REGULATOR_MODE_NORMAL;
> -	else if (strncmp(buf, "idle", strlen("idle")) == 0)
> +	else if (sysfs_streq(buf, "idle\n") == 0)
>  		mode = REGULATOR_MODE_IDLE;
> -	else if (strncmp(buf, "standby", strlen("standby")) == 0)
> +	else if (sysfs_streq(buf, "standby\n") == 0)
>  		mode = REGULATOR_MODE_STANDBY;

we don't need the \n's, do we?
