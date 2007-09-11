Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXIKH6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXIKH6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 03:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbXIKH6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 03:58:03 -0400
Received: from www.osadl.org ([213.239.205.134]:59008 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753492AbXIKH6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 03:58:01 -0400
Subject: Re: Fix "no_sync_cmos_clock"  logic inversion in kernel/time/ntp.c
From: Thomas Gleixner <tglx@linutronix.de>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Gabriel Paubert <paubert@iram.es>,
       zach@vmware.com, John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20070911074608.GD9814@bakeyournoodle.com>
References: <20070911074608.GD9814@bakeyournoodle.com>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 09:57:50 +0200
Message-Id: <1189497470.22589.3.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 17:46 +1000, Tony Breeds wrote:
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> 
> ---
> 
> Seems to me that this timer will only get started on platforms that say
> they don't want it?

Hell, yes. Good catch !

	tglx

>  kernel/time/ntp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: working/kernel/time/ntp.c
> ===================================================================
> --- working.orig/kernel/time/ntp.c	2007-09-11 17:34:44.000000000 +1000
> +++ working/kernel/time/ntp.c	2007-09-11 17:34:55.000000000 +1000
> @@ -226,7 +226,7 @@ static void sync_cmos_clock(unsigned lon
>  
>  static void notify_cmos_timer(void)
>  {
> -	if (no_sync_cmos_clock)
> +	if (!no_sync_cmos_clock)
>  		mod_timer(&sync_cmos_timer, jiffies + 1);
>  }
>  
> 
> Yours Tony
> 
>   linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
>   Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!
> 

