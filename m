Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYJ3QYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYJ3QYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbYJ3QYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:24:02 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12447 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbYJ3QYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:24:00 -0400
Date: Thu, 30 Oct 2008 09:22:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Power Management support requires RTC_CLASS
Message-Id: <20081030092255.948a7063.randy.dunlap@oracle.com>
In-Reply-To: <20081031000407.8f16beb0.yoichi_yuasa@tripeaks.co.jp>
References: <20081031000407.8f16beb0.yoichi_yuasa@tripeaks.co.jp>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008 00:04:07 +0900 Yoichi Yuasa wrote:

> kernel/built-in.o: In function `test_wakealarm':
> linux/kernel/power/main.c:619: undefined reference to `rtc_read_time'
> linux/kernel/power/main.c:619: relocation truncated to fit: R_MIPS_26 against `rtc_read_time'
> linux/kernel/power/main.c:630: undefined reference to `rtc_set_alarm'
> linux/kernel/power/main.c:630: relocation truncated to fit: R_MIPS_26 against `rtc_set_alarm'
> linux/kernel/power/main.c:654: undefined reference to `rtc_set_alarm'
> linux/kernel/power/main.c:654: relocation truncated to fit: R_MIPS_26 against `rtc_set_alarm'
> kernel/built-in.o: In function `test_suspend':
> linux/kernel/power/main.c:718: undefined reference to `rtc_class_open'
> linux/kernel/power/main.c:718: relocation truncated to fit: R_MIPS_26 against `rtc_class_open'
> linux/kernel/power/main.c:726: undefined reference to `rtc_class_close'
> linux/kernel/power/main.c:726: relocation truncated to fit: R_MIPS_26 against `rtc_class_close'
> kernel/built-in.o: In function `valid_state':
> linux/kernel/power/main.c:403: undefined reference to `rtc_class'
> kernel/built-in.o: In function `test_suspend':
> linux/kernel/power/main.c:716: undefined reference to `rtc_class'
> 
> Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> 
> diff -pruN -X /home/yuasa/Memo/dontdiff linux-orig/kernel/power/Kconfig linux/kernel/power/Kconfig
> --- linux-orig/kernel/power/Kconfig	2008-10-22 09:41:32.154425163 +0900
> +++ linux/kernel/power/Kconfig	2008-10-22 11:04:48.230018848 +0900
> @@ -1,6 +1,7 @@
>  config PM
>  	bool "Power Management support"
>  	depends on !IA64_HP_SIM
> +	select RTC_CLASS
>  	---help---
>  	  "Power Management" means that parts of your computer are shut
>  	  off or put into a power conserving "sleep" mode if they are not
> --

That should only be needed for the code block that is surrounded by

#ifdef CONFIG_PM_TEST_SUSPEND
...
#endif /* CONFIG_PM_TEST_SUSPEND */

and the Kconfig file already contains

config PM_TEST_SUSPEND
	bool "Test suspend/resume and wakealarm during bootup"
	depends on SUSPEND && PM_DEBUG && RTC_LIB=y

so maybe that needs to be changed to use RTC_CLASS.  I dunno.

---
~Randy
