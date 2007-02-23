Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbXBWWNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbXBWWNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 17:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933244AbXBWWNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 17:13:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:41288 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933245AbXBWWNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 17:13:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=REm2fpNRFA9Oon8XxMAjj6etO/zxRobchn1qpxO3/s82r7DGH3GNKlG5e/BbtnaGYeTGJ0Jza6c9R/iWsx+Jhk2w7RM/XAskqpxfH5QrMqvc9fxuYrv+0WJa1bySHni1ydXCps7D0Fz8Nw839uCd2TQqWAewxLxpuIfaAdfZuIE=
Message-ID: <1f1b08da0702231413s21613fa0nf2b1df5d23fef440@mail.gmail.com>
Date: Fri, 23 Feb 2007 14:13:07 -0800
From: "john stultz" <johnstul@us.ibm.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: radeon breaks with clocksource_jiffies
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1f1b08da0702231408l19207805o5555ee3ebf6bd426@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070223.134505.74749340.davem@davemloft.net>
	 <1f1b08da0702231408l19207805o5555ee3ebf6bd426@mail.gmail.com>
X-Google-Sender-Auth: 4ae37bd2e9989e75
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Crud, my poor gmail skills dropped lkml on the CC list for this one.

On 2/23/07, john stultz <johnstul@us.ibm.com> wrote:
> On 2/23/07, David Miller <davem@davemloft.net> wrote:
> > While probeing PLL information via radeon_get_pllinfo(), it does a
> > "gettimeofday(); do_something(); gettimeofday();" type sequence
> > explicitly with interrupts disabled, so ends up with a zero
> > measurement which then results in a bunch of divisions by zero.
>
> This is at module init time?  If so I just sent out a patch yesterday
> to akpm that might help this issue (assuming other clocksources are
> available on the hardware).
>
>
> > We should decide whether gettimeofday() can be expected to advance with
> > interrupts disabled, or that clocksource_jiffies is simply invalid because
> > of this behavior.
>
> Some arches have no fine-grained timekeeping, so I don't think it can
> always be assumed, but where hardware is available it should function.
>
> It should be noted that with older kernels, if interrupts were
> disabled right before a tick, it would be possible that
> gettimeofday()'s limiting code would cause time to stop advancing
> until interrupts were re-enabled. So theoretically its not really a
> new issue.
>
> The timekeeping_is_continuous() function could be used to flag this
> sort of "software driven vs continuous" clocksource cases.
>
> thanks
> -john
>
