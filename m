Return-Path: <linux-kernel-owner+w=401wt.eu-S1750993AbZLNFR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993AbZLNFR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZLNFRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:17:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45702 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZLNFRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:17:54 -0500
Date: Mon, 14 Dec 2009 06:17:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: re.emese@gmail.com
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 05/10] Constify struct platform_suspend_ops for
 2.6.32-git-053fe57ac v2
Message-ID: <20091214051745.GG5114@elf.ucw.cz>
References: <cover.1260663003.git.re.emese@gmail.com>
 <2218084c294878ee335de04178d4c0b93167e248.1260663003.git.re.emese@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2218084c294878ee335de04178d4c0b93167e248.1260663003.git.re.emese@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-12-14 01:00:21, re.emese@gmail.com wrote:
> From: Emese Revfy <re.emese@gmail.com>
> 
> 
> Signed-off-by: Emese Revfy <re.emese@gmail.com>

It definitely needs an explanation, and it has none.

> index 5e781d8..3a2553d 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -104,15 +104,15 @@ typedef int __bitwise suspend_state_t;
>   *	which require special recovery actions in that situation.
>   */
>  struct platform_suspend_ops {
> -	int (*valid)(suspend_state_t state);
> -	int (*begin)(suspend_state_t state);
> -	int (*prepare)(void);
> -	int (*prepare_late)(void);
> -	int (*enter)(suspend_state_t state);
> -	void (*wake)(void);
> -	void (*finish)(void);
> -	void (*end)(void);
> -	void (*recover)(void);
> +	int (* const valid)(suspend_state_t state);
> +	int (* const begin)(suspend_state_t state);
> +	int (* const prepare)(void);
> +	int (* const prepare_late)(void);
> +	int (* const enter)(suspend_state_t state);
> +	void (* const wake)(void);
> +	void (* const finish)(void);
> +	void (* const end)(void);
> +	void (* const recover)(void);
>  };
>

I'm not sure what this is good for. Are you afraid that I'd do 
*(char *)ops->end = 0x90 , or what?

> @@ -120,7 +120,7 @@ struct platform_suspend_ops {
>   * suspend_set_ops - set platform dependent suspend operations
>   * @ops: The new suspend operations to set.
>   */
> -extern void suspend_set_ops(struct platform_suspend_ops *ops);
> +extern void suspend_set_ops(const struct platform_suspend_ops *ops);
>  extern int suspend_valid_only_mem(suspend_state_t state);
>

These I can at least understand, and are probably ok.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
