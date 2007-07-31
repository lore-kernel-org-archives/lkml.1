Return-Path: <linux-kernel-owner+w=401wt.eu-S940343AbXGaBHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940343AbXGaBHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937828AbXGaBHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:07:23 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:1486 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763381AbXGaBHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:07:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dNxJ/+uSu7gjcfKaGo30n1/C1b5WJRX2UgmINX+zFTNRauLQar6ilgH/8GcL5j4ly6ULyEL4iT5DwC9k1CcdhmbWOV/vO7gYIZpfMgXrtrj3f/vLwCqYiF6NppsqM8pEG043/UEA70tm5KwcIJc7JHzcGrqqHwiWqprna7dUTlU=
Message-ID: <1f1b08da0707301807h62a24b3o786beed607ae5fcd@mail.gmail.com>
Date: Mon, 30 Jul 2007 18:07:19 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: "Vasily Averin" <vvs@sw.ru>
Subject: Re: [2.6.22] negative time jump
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1f1b08da0707301113r173adba0yd2585263e89fd8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46AD57BF.8090106@sw.ru>
	 <1f1b08da0707301113r173adba0yd2585263e89fd8@mail.gmail.com>
X-Google-Sender-Auth: be8cda38f6a08725
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, forgot to CC lkml.

---------- Forwarded message ----------
From: john stultz <johnstul@us.ibm.com>
Date: Jul 30, 2007 11:13 AM
Subject: Re: [2.6.22] negative time jump
To: Vasily Averin <vvs@sw.ru>


On 7/29/07, Vasily Averin <vvs@sw.ru> wrote:
> I've investigated why my testnode freezes. When I found that node is freezed
> again I've started to press Sysrq keys and noticed the following negative time jump.
>
> Could anybody please help me to understand the reasons of this issue?
>
> --- VvS comment: some pre-history: node boot
> Jul 27 13:58:10 ts28 Linux version 2.6.22 (vvs@vvs.work.ve) (gcc version 3.4.6
> 20060404 (Red Hat 3.4.6-3)) #11 SMP Fri Jul 27 12:47:45 MSD 2007
> Jul 27 13:58:10 ts28 Command line: ro root=LABEL=/1 console=ttyS0,115200
> console=tty debug silencelevel=8 crashkernel=128M@128M acpc=noirq clocksource=tsc

clocksource=tsc?

I suspect you're forcing the clocksource as its not selected by
default. Could you provide dmesg output without that option. It might
shed some light as to why the clocksource isn't chosen.

It may very well be your TSCs are not synched or are otherwise not
reliable for timekeeping , and thus time is not consistent between
cpus.

-john

PS: also, you might want to check that acpc=noirq bit as well.. i
think you mean "acpi=noirq"
