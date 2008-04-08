Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYDHKB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYDHKB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 06:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYDHKBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 06:01:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:58925 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYDHKBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 06:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CDiHlG2ScTJEJjddjzpfKMpCZsby0+O9dhxuJJ7ztM8VzTkbsGKT1pWyhG8Z+EurxFMv/l84NeXfKTlFU7w3AW3hOeAWniTmgnRcEL1mrPs8WWGc3Fbz+P6gaX2+njDY1Tw7Rc2D2aNin+xuVbaFLjhHzeAcH8ADODJkbhiaxLo=
Message-ID: <f17812d70804080301j5670244dr21346e75c4744eab@mail.gmail.com>
Date: Tue, 8 Apr 2008 18:01:46 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] pxafb: move parallel LCD timing setup into dedicate function
Cc: "linux-arm-kernel email list" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Daniel Mack" <daniel@caiaq.de>
In-Reply-To: <20080408012136.30b71560.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70804072105r57413cc4gba7f66abb4724809@mail.gmail.com>
	 <20080408012136.30b71560.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 4:21 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 8 Apr 2008 12:05:16 +0800 "eric miao" <eric.y.miao@gmail.com> wrote:
>
>  > @@ -636,61 +671,31 @@ static int pxafb_activate_var(struct
>  > fb_var_screeninfo *var,
>  >               printk(KERN_ERR "%s: invalid lower_margin %d\n",
>  >                       fbi->fb.fix.id, var->lower_margin);
>  >  #endif
>  > +     /* Update shadow copy atomically */
>  > +     local_irq_save(flags);
>
>  So this code will only ever work on uniprocessor machines?
>
>  Is this a safe and reasonable assumption?
>

Y, this is a reasonable assumption for PXA2xx/3xx, though as noted in
the comment, it's too heavy for an local_irq_{save,restore} here, but
a fix to this would involve more investigation, so I'd rather have this
fixed later.

-- 
Cheers
- eric
