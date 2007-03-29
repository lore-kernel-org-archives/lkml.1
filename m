Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbXC2NUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbXC2NUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 09:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbXC2NUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 09:20:01 -0400
Received: from h155.mvista.com ([63.81.120.155]:21936 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753457AbXC2NT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 09:19:59 -0400
Message-ID: <460BBD1B.4040308@ru.mvista.com>
Date: Thu, 29 Mar 2007 17:20:27 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Maxim <maximlevitsky@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: [ PATCH] Add suspend/resume for HPET was: Re: [3/6] 2.6.21-rc4:
 known regressions
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703290641.20236.maximlevitsky@gmail.com> <Pine.LNX.4.64.0703282203550.6730@woody.linux-foundation.org> <200703290747.28929.maximlevitsky@gmail.com>
In-Reply-To: <200703290747.28929.maximlevitsky@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Maxim wrote:

> ---
> This adds support of suspend/resume on i386 for HPET

   The part after usually "---" gets cut off, the patch description and 
signoff should actially *precede* it.

> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

> diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
> index 0fd9fba..7c67780 100644
> --- a/arch/i386/kernel/hpet.c
> +++ b/arch/i386/kernel/hpet.c
[...]
> +static __init int hpet_register_sysfs(void)
> +{
> +	int err;
> +
> +	if (!is_hpet_capable())
> +		return 0;
> +
> +	err = sysdev_class_register(&hpet_class);
> +
> +	if (!err) {
> +		sysdev_register(&hpet_device);
> +		if (err)
> +			sysdev_class_unregister(&hpet_class);

    This doesn't make sense, err will always be 0.  Perhaps you actually 
intended to check the result of sysdev_register()?

> +	}
> +
> +	return err;
> +}
> +
> +device_initcall(hpet_register_sysfs);
> +
> +#endif

WBR, Sergei
