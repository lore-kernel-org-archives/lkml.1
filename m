Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbYFWIeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbYFWIeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYFWIeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:34:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:17533 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYFWIeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QIHrWj95TpL39RDEgBmspTyoqvjq9xf1B6eBCu3KAs4cvnZVBpY7C/raZo64NBoanA
         uDXrxr4pLw3HyLPJmvE9BYrGDZTCg59A9Piarxdpff1+BxUw6nfH/yZV7+8eQdc673Qc
         nagqphQGDwvoYlOc2ZKKdwAei5ZDy3qfNBPgc=
Message-ID: <e2e108260806230134g48f5ac63mb93256e08c57b4f7@mail.gmail.com>
Date: Mon, 23 Jun 2008 10:34:05 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Michael Kerrisk" <mtk.manpages@gmail.com>
Subject: Re: nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "john stultz" <johnstul@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <485E00CD.9060503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485E00CD.9060503@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 9:35 AM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
> Thomas,
>
> (I gues you are the right target for this?)
>
> The POSIX.1 specification of nanosleep() says:
>
>       But, except for the case of being interrupted by a signal, the
>       suspension time shall not be less than the time  specified  by
>       rqtp, as measured by the system clock CLOCK_REALTIME.
>
>
> However, reading kernel/hrtimer.c:sys_nanosleep(), it appears that
> CLOCK_MONOTONIC is used.
>
>    return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
>
> Is there a reason to use CLOCK_MONOTONIC, instead of CLOCK_REALTIME?  Is it
> intentional?  If yes, then I should document this in the man-pages.  If not,
> then it should be fixed.

CLOCK_MONOTONIC works fine even if ntpd steps the clock forward or
backward, CLOCK_REALTIME not. So the man page should be fixed.

Strange to find such phrases in the POSIX specs ...

Bart.
