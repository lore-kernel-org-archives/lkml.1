Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbXLUKSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbXLUKSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 05:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbXLUKR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 05:17:56 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37864 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750938AbXLUKRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 05:17:55 -0500
Date: Fri, 21 Dec 2007 11:17:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 2/3 -mm] kexec jump -v8 : add write support to oldmem
	device
Message-ID: <20071221101710.GB10573@elf.ucw.cz>
References: <1198222420.1965.21.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198222420.1965.21.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch adds writing support for /dev/oldmem. This can be used to
> 
> - Communicate between original kernel and kexeced kernel through write
>   to some pages in original kernel.
> 
> - Restore the memory contents of hibernated system in kexec based
>   hibernation.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> --- a/arch/x86/kernel/crash_dump_32.c
> +++ b/arch/x86/kernel/crash_dump_32.c
> +ssize_t write_oldmem_page(unsigned long pfn, const char *buf,
> +			  size_t csize, unsigned long offset, int
> userbuf)

> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -348,6 +348,37 @@ static ssize_t read_oldmem(struct file *
>  	}
>  	return read;
>  }
> +
> +/*
> + * Write memory corresponding to the old kernel.
> + */
> +static ssize_t write_oldmem(struct file *file, const char __user *buf,
> +			    size_t count, loff_t *ppos)
> +{
...
> +		rc = write_oldmem_page(pfn, buf, csize, offset, 1);

I believe this is going to break compilation on non-32bit
machines. Or is crashdump only supported on i386?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
