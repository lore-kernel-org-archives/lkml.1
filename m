Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbZETVFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbZETVFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 17:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZETVFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 17:05:02 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:15598 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbZETVFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 17:05:01 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4A147078.6020208@tremplin-utc.net>
Date: Wed, 20 May 2009 23:04:56 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Christian Thaeter <ct@pipapo.org>
CC: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hpfall.c improvements, thoughts
References: <49C8F338.7030901@pipapo.org> <20090324211555.GA24172@elf.ucw.cz> <49CAA1DF.8060109@pipapo.org>
In-Reply-To: <49CAA1DF.8060109@pipapo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 25-03-09 22:27, Christian Thaeter schreef:
> Some conversation I had with Pavel,
> 
> imo the example code should be at least barely useable as in not causing
> harm like I sketched in (1.). Maybe someone else picks that up and
> improves it later on. Patch at the end, quite sketchy and imature as it
> doesn't check for errors, but certainly better than before.
> 
Hello Christian,
Would you mind resending the patch with a changelog, so that Andrew can
merge it?

Thanks,
Eric

> 
> Signed-off-by: Christian Thaeter <ct@pipapo.org>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>

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

