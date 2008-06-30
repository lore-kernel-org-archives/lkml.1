Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbYF3WIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbYF3WIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbYF3WHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:07:46 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45194 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796AbYF3WHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:07:45 -0400
Subject: Re: [patch] ADJ_OFFSET_SS_READ and capabilities
From: john stultz <johnstul@us.ibm.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <485E002B.5010101@gmail.com>
References: <485DF41E.9020909@gmail.com>  <485E002B.5010101@gmail.com>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 15:07:40 -0700
Message-Id: <1214863660.3143.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-06-22 at 09:32 +0200, Michael Kerrisk wrote:
> Hi Roman, John,
> 
> ADJ_OFFSET_SS_READ is a read-only operation.  Therefore, it seems
> reasonable not to require any capability (as is the case when 'modes'
> is zero.  See the patch below.  Does this change seem reasonable?
> 
> Cheers,
> 
> Michael
> 
> --- linux-2.6.26-rc5/kernel/time/ntp.c	2008-06-13 11:16:51.000000000 +0200
> +++ linux-2.6.26-rc5-p/kernel/time/ntp.c	2008-06-22 07:31:43.000000000 +0200
> @@ -281,7 +281,8 @@
>   	int result;
> 
>   	/* In order to modify anything, you gotta be super-user! */
> -	if (txc->modes && !capable(CAP_SYS_TIME))
> +	if (txc->modes && txc->modes != ADJ_OFFSET_SS_READ &&
> +	    !capable(CAP_SYS_TIME))
>   		return -EPERM;
> 
>   	/* Now we validate the data before disabling interrupts */
> 


Hey Michael,
	This seems like an ok change, but we'd first want to fix the issue you
pointed out earlier which would make sure adjtimex() read calls don't
cause side effects.

thanks
-john



