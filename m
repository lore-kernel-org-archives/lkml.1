Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZKML1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZKML1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZKML1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:27:20 -0500
Received: from smtp.nokia.com ([192.100.122.233]:31728 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbZKML1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 06:27:19 -0500
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
In-Reply-To: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 13:26:46 +0200
Message-Id: <1258111606.21596.1208.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Nov 2009 11:26:49.0642 (UTC) FILETIME=[310C98A0:01CA6454]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 21:13 -0500, David VomLehn wrote:
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 96b45d0..513deae 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -70,6 +70,7 @@ NORET_TYPE void panic(const char * fmt, ...)
>         vsnprintf(buf, sizeof(buf), fmt, args);
>         va_end(args);
>         printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
> +       panic_note_print();
>  #ifdef CONFIG_DEBUG_BUGVERBOSE
>         dump_stack();
>  #endif
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug

You should use panic notifiers instead. See the panic_notifier_list.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

