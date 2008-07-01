Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbYGAMrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbYGAMrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYGAMrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:47:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:42680 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbYGAMrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NxUYS215TVfiMexeolLwDtsSnT+9Vc732zD2R2DSiZxTCH5BJIdxFxryZz39UZCiC2
         nAQv+tQqv1LI71vlON61wEvJLYsTRCbRwrMMEqQB+R68/IBDO58n77qFvRwAtekaiZnp
         01y0DDGwEB8BW9xA8v3FHV5pQ9WSHNZOGjTug=
Date: Tue, 1 Jul 2008 08:46:54 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] drivers/input/ff-core.c needs <linux/sched.h>
Message-ID: <20080701084316.ZZRA012@mailhub.coreip.homeip.net>
References: <Pine.LNX.4.64.0807011300110.21227@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807011300110.21227@anakin>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 01:55:25PM +0200, Geert Uytterhoeven wrote:
> commit 656acd2bbc4ce7f224de499ee255698701396c48
> Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Date:   Thu Jun 26 11:30:02 2008 -0400
> 
>     Input: fix locking in force-feedback core
> 
>     The newly added event_lock spinlock in the input core disallows sleeping
>     and therefore using mutexes in event handlers. Convert force-feedback 
>     core to rely on event_lock instead of mutex to protect slots allocated  
>     for fore-feedback effects. The original mutex is still used to serialize
>     uploading and erasing of effects.
> 
> causes the following regression on m68k:
> 
> | linux/drivers/input/ff-core.c: In function 'input_ff_upload':
> | linux/drivers/input/ff-core.c:172: error: dereferencing pointer to incomplete type
> | linux/drivers/input/ff-core.c: In function 'erase_effect':
> | linux/drivers/input/ff-core.c:197: error: dereferencing pointer to incomplete type
> | linux/drivers/input/ff-core.c:204: error: dereferencing pointer to incomplete type
> | make[4]: *** [drivers/input/ff-core.o] Error 1
> 

Argh! Sorry about it.

> As the incomplete type is `struct task_struct', including <linux/sched.h> fixes
> it.

Not linux/spinlock.h? I wonder if I need to include linux/spinlock.h and
linux/mutex.h directly from linux/input.h... What is the current
policy on headers - do they need to include everything to be
functional or it is responsibility of the user?

-- 
Dmitry
