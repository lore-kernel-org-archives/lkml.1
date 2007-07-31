Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbXGaJu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbXGaJu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbXGaJuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:50:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42078 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752631AbXGaJuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:50:50 -0400
Date: Tue, 31 Jul 2007 11:51:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATH 1/1] Kexec jump - v2 - kexec jump
Message-ID: <20070731095101.GA1774@elf.ucw.cz>
References: <1184483639.1898.99.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184483639.1898.99.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch implement the functionality of jumping from kexeced kernel
> to original kernel.
> 
> A new reboot command named LINUX_REBOOT_CMD_KJUMP is defined to
> trigger the jumping to (executing) the new kernel or jumping back to
> the original kernel.

Could we get two reboot commands? Exec loaded kernel seems to be quite
different operation than "jump back".

How do I test these patches? kexec -p <bzImage>, then kexec -j?


> +static unsigned long kexec_backup_addr = ~0UL;
> +
> +/* kexec_backup= specifies the location of backuped 0~640k memory of
> + * crashed kernel.
> + */
> +static int __init parse_kexec_backup(char *arg)
> +{
> +	if (!arg)
> +		return -EINVAL;
> +
> +	kexec_backup_addr = memparse(arg, &arg);
> +	return 0;
> +}
> +early_param("kexec_backup", parse_kexec_backup);

New kernel parameters should be documented. (Plus I do not know how to
use this one, please help :-).


> +int kexec_flags;
> +
> +static unsigned long kexec_jump_buf_pfn;
> +
> +static int __init parse_kexec_jump_buf_pfn(char *arg)
> +{
> +	if (!arg)
> +		return -EINVAL;
> +
> +	kexec_jump_buf_pfn = memparse(arg, &arg);
> +	kexec_flags |= KEXEC_FLAGS_IS_KEXECED_KERNEL;
> +	return 0;
> +}
> +early_param("kexec_jump_buf_pfn", parse_kexec_jump_buf_pfn);

This one should be documented, too, I'd guess. (Is that internal,
kernel-to-kernel communication?)

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
