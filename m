Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbZJEMCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbZJEMCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 08:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758503AbZJEMCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 08:02:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56109 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295AbZJEMB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 08:01:59 -0400
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
References: <cover.1254701151.git.joe@perches.com>
	<cover.1254701151.git.joe@perches.com>
	<40ffa7c5595f4afbba793919b397b5139cde901a.1254701151.git.joe@perches.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 05 Oct 2009 05:01:16 -0700
In-Reply-To: <40ffa7c5595f4afbba793919b397b5139cde901a.1254701151.git.joe@perches.com> (Joe Perches's message of "Sun\,  4 Oct 2009 17\:53\:43 -0700")
Message-ID: <m163auvylv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Joe Perches <joe@perches.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_05 8+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 16/21] kernel/kexec.c: use pr_<level> and add pr_fmt(fmt)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Converted printk(KERN_<level> to pr_<level>(
> Added KERN_ERR to allocation failure message

I'm dense and I haven't seen the discussions.  What
is the point of adding a prefix string where none exists
into a bunch of printks?

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  kernel/kexec.c |   21 ++++++++++-----------
>  1 files changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index f336e21..e805351 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -6,6 +6,8 @@
>   * Version 2.  See the file COPYING for more details.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/capability.h>
>  #include <linux/mm.h>
>  #include <linux/file.h>
> @@ -245,13 +247,13 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
>  	image->control_code_page = kimage_alloc_control_pages(image,
>  					   get_order(KEXEC_CONTROL_PAGE_SIZE));
>  	if (!image->control_code_page) {
> -		printk(KERN_ERR "Could not allocate control_code_buffer\n");
> +		pr_err("Could not allocate control_code_buffer\n");
>  		goto out;
>  	}
>  
>  	image->swap_page = kimage_alloc_control_pages(image, 0);
>  	if (!image->swap_page) {
> -		printk(KERN_ERR "Could not allocate swap buffer\n");
> +		pr_err("Could not allocate swap buffer\n");
>  		goto out;
>  	}
>  
> @@ -320,7 +322,7 @@ static int kimage_crash_alloc(struct kimage **rimage, unsigned long entry,
>  	image->control_code_page = kimage_alloc_control_pages(image,
>  					   get_order(KEXEC_CONTROL_PAGE_SIZE));
>  	if (!image->control_code_page) {
> -		printk(KERN_ERR "Could not allocate control_code_buffer\n");
> +		pr_err("Could not allocate control_code_buffer\n");
>  		goto out;
>  	}
>  
> @@ -1141,8 +1143,7 @@ static int __init crash_notes_memory_init(void)
>  	/* Allocate memory for saving cpu registers. */
>  	crash_notes = alloc_percpu(note_buf_t);
>  	if (!crash_notes) {
> -		printk("Kexec: Memory allocation for saving cpu register"
> -		" states failed\n");
> +		pr_err("Memory allocation for saving cpu register states failed\n");
>  		return -ENOMEM;
>  	}
>  	return 0;
> @@ -1192,8 +1193,7 @@ static int __init parse_crashkernel_mem(char 			*cmdline,
>  		if (*cur != ':') {
>  			end = memparse(cur, &tmp);
>  			if (cur == tmp) {
> -				pr_warning("crashkernel: Memory "
> -						"value expected\n");
> +				pr_warning("crashkernel: Memory value expected\n");
>  				return -EINVAL;
>  			}
>  			cur = tmp;
> @@ -1211,7 +1211,7 @@ static int __init parse_crashkernel_mem(char 			*cmdline,
>  
>  		size = memparse(cur, &tmp);
>  		if (cur == tmp) {
> -			pr_warning("Memory value expected\n");
> +			pr_warning("crashkernel: Memory value expected\n");
>  			return -EINVAL;
>  		}
>  		cur = tmp;
> @@ -1234,8 +1234,7 @@ static int __init parse_crashkernel_mem(char 			*cmdline,
>  			cur++;
>  			*crash_base = memparse(cur, &tmp);
>  			if (cur == tmp) {
> -				pr_warning("Memory value expected "
> -						"after '@'\n");
> +				pr_warning("crashkernel: Memory value expected after '@'\n");
>  				return -EINVAL;
>  			}
>  		}
> @@ -1473,7 +1472,7 @@ int kernel_kexec(void)
>  #endif
>  	{
>  		kernel_restart_prepare(NULL);
> -		printk(KERN_EMERG "Starting new kernel\n");
> +		pr_emerg("Starting new kernel\n");
>  		machine_shutdown();
>  	}
>  
> -- 
> 1.6.3.1.10.g659a0.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
