Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYDHIWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYDHIWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYDHIWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:22:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbYDHIWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:22:15 -0400
Date: Tue, 8 Apr 2008 01:21:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "eric miao" <eric.y.miao@gmail.com>
Cc: "linux-arm-kernel email list" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Daniel Mack" <daniel@caiaq.de>
Subject: Re: [PATCH 3/4] pxafb: move parallel LCD timing setup into dedicate
 function
Message-Id: <20080408012136.30b71560.akpm@linux-foundation.org>
In-Reply-To: <f17812d70804072105r57413cc4gba7f66abb4724809@mail.gmail.com>
References: <f17812d70804072105r57413cc4gba7f66abb4724809@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008 12:05:16 +0800 "eric miao" <eric.y.miao@gmail.com> wrote:

> @@ -636,61 +671,31 @@ static int pxafb_activate_var(struct
> fb_var_screeninfo *var,
>  		printk(KERN_ERR "%s: invalid lower_margin %d\n",
>  			fbi->fb.fix.id, var->lower_margin);
>  #endif
> +	/* Update shadow copy atomically */
> +	local_irq_save(flags);

So this code will only ever work on uniprocessor machines?

Is this a safe and reasonable assumption?
