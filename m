Return-Path: <linux-kernel-owner+w=401wt.eu-S933822AbXJQRQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822AbXJQRQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758767AbXJQRQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:16:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41682 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbXJQRQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:16:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Qi Yong <qiyong@fc-cn.com>
Subject: Re: [PATCH] swsusp: Use platform mode by default
Date: Wed, 17 Oct 2007 19:32:08 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, linux-acpi@vger.kernel.org,
       Stefan Seyfried <seife@suse.de>
References: <200611011323.14830.rjw@sisk.pl> <2cd57c900710161946h4396029eoe75522119370309@mail.gmail.com> <20071017034402.GA10260@virgo.fc-cn.com>
In-Reply-To: <20071017034402.GA10260@virgo.fc-cn.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710171932.09123.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 17 October 2007 05:44, Qi Yong wrote:
> On Wed, Oct 17, 2007 at 10:46:12AM +0800, Qi Yong wrote:
> > On 12/05/2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > On Fri, 11 May 2007, Rafael J. Wysocki wrote:
[--snip--]
> 
> please apply.
> 
> Signed-off-by: Qi Yong <qiyong@fc-cn.com>
> ---

With your patch applied the default for ACPI systems changes from
HIBERNATION_PLATFORM to HIBERNATION_SHUTDOWN.  However,
it has been HIBERNATION_PLATFORM since 2.6.20 and I'd really
prefer it to stay this way.

If HIBERNATION_PLATFORM doesn't work for you, please do
"echo shutdown > /sys/power/disk" before hibernation or, if you use the
userland suspend tools, change the s2disk's configuration file to use the
"shutdown" mode.

> diff --git a/kernel/power/disk.c b/kernel/power/disk.c
> index eb72255..95b66ee 100644
> --- a/kernel/power/disk.c
> +++ b/kernel/power/disk.c
> @@ -61,9 +61,11 @@ void hibernation_set_ops(struct hibernation_ops *ops)
>  	}
>  	mutex_lock(&pm_mutex);
>  	hibernation_ops = ops;
> -	if (ops)
> -		hibernation_mode = HIBERNATION_PLATFORM;
> -	else if (hibernation_mode == HIBERNATION_PLATFORM)
> +
> +	/*
> +	 * Turn off HIBERNATION_PLATFORM if we no longer have any platform ops.
> +	 */
> +	if (!ops && hibernation_mode == HIBERNATION_PLATFORM)
>  		hibernation_mode = HIBERNATION_SHUTDOWN;
>  
>  	mutex_unlock(&pm_mutex);

Greetings,
Rafael
