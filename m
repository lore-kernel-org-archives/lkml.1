Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZCYVbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZCYVbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZCYVbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:31:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45276 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZCYVa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:30:59 -0400
Date: Wed, 25 Mar 2009 22:33:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Christian Thaeter <ct@pipapo.org>
Cc: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net
Subject: Re: [PATCH] hpfall.c improvements, thoughts
Message-ID: <20090325213345.GD6708@elf.ucw.cz>
References: <49C8F338.7030901@pipapo.org> <20090324211555.GA24172@elf.ucw.cz> <49CAA1DF.8060109@pipapo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CAA1DF.8060109@pipapo.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Some conversation I had with Pavel,
> 
> imo the example code should be at least barely useable as in not causing
> harm like I sketched in (1.). Maybe someone else picks that up and
> improves it later on. Patch at the end, quite sketchy and imature as it
> doesn't check for errors, but certainly better than before.

Thanks. Acked-by: Pavel Machek <pavel@ucw.cz>
									Pavel


> Signed-off-by: Christian Thaeter <ct@pipapo.org>
> ---
> 
> diff --git a/Documentation/hwmon/hpfall.c b/Documentation/hwmon/hpfall.c
> index bbea1cc..f3cde67 100644
> --- a/Documentation/hwmon/hpfall.c
> +++ b/Documentation/hwmon/hpfall.c
> @@ -16,6 +16,8 @@
>  #include <stdint.h>
>  #include <errno.h>
>  #include <signal.h>
> +#include <sys/mman.h>
> +#include <sched.h>
> 
>  void write_int(char *path, int i)
>  {
> @@ -63,6 +65,7 @@ void ignore_me(void)
>  int main(int argc, char* argv[])
>  {
>         int fd, ret;
> +       struct sched_param param;
> 
>         fd = open("/dev/freefall", O_RDONLY);
>         if (fd < 0) {
> @@ -70,7 +73,12 @@ int main(int argc, char* argv[])
>                 return EXIT_FAILURE;
>         }
> 
> -	signal(SIGALRM, ignore_me);
> +       daemon(0,0);
> +       param.sched_priority = sched_get_priority_max(SCHED_FIFO);
> +       sched_setscheduler(0, SCHED_FIFO, &param);
> +       mlockall(MCL_CURRENT|MCL_FUTURE);
> +
> +       signal(SIGALRM, ignore_me);
> 
>         for (;;) {
>  	       unsigned char count;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
