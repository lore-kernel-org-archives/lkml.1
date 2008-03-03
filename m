Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYCCOp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYCCOp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbYCCOn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:43:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37164 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbYCCOn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:43:56 -0500
Date: Mon, 3 Mar 2008 15:18:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH RFC] introduce pm_call() macro to get rid of most
	#ifdef CONFIG_PM
Message-ID: <20080303141818.GE12606@elf.ucw.cz>
References: <20080302234308.GA10116@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080302234308.GA10116@zarina>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index 015b735..6e0b9c2 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -114,6 +114,13 @@ typedef struct pm_message {
>  	int event;
>  } pm_message_t;
>  
> +#ifdef CONFIG_PM
> +#define pm_call(x) (x)
> +#else
> +/* avoid `defined but not used' warning */
> +#define pm_call(x) ((x) - 1 ? NULL : NULL)
> +#endif /* CONFIG_PM */
> +

This is evil. Maybe your gcc is smart enough to optimize this away,
but I'm not sure mine is.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
