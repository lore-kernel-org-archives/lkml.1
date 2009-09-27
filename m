Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZI0RmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZI0RmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 13:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZI0RmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 13:42:19 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:56259 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZI0RmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 13:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OQkRPdlNip2GrF7n3CqQdtxiYMTp0kSmy1Si1ILXG9RaXs+encd6jAlspv1hcu/vLL
         DtRjMJ3nB1bUtFEj0upBWp4+C1PYHbiLbHcPkvbv8baP0qA2QGHZF6KtkcLmJry0wjXo
         RXEimffvpk7rDNMOt/xXIRpAhDrZQ7qwtn1MM=
Date: Sun, 27 Sep 2009 21:42:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add show_lapic=
Message-ID: <20090927174219.GA14280@lenovo>
References: <4ABF0DE0.1030400@kernel.org> <20090927080605.GA4984@lenovo> <4ABF2262.3090905@kernel.org> <20090927085406.GB4984@lenovo> <20090927102805.GC4984@lenovo> <20090927144008.GD4984@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927144008.GD4984@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Sep 27, 2009 at 06:40:08PM +0400]
...
| @@ -1866,21 +1863,37 @@ __apicdebuginit(void) print_PIC(void)
|  	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
|  }
|  
| -__apicdebuginit(int) print_all_ICs(void)
| +static int __initdata show_lapic = NR_CPUS;
| +static __init int setup_show_lapic(char *arg)
|  {
| +	int num = 0;
| +
| +	get_option(&arg, &num);
| +	if (num >= 0)
| +		show_lapic = num;
| +
| +	return 1;
| +}
| +__setup("show_lapic=", setup_show_lapic);
| +
...

Sigh... this is wrong as well. The proper initial value
should be -1 :(

	-- Cyrill
