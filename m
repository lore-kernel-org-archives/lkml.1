Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520Ab0ASWs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0ASWs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052Ab0ASWs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:48:26 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:60782 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab0ASWsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:48:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TmF3t7zeM80G8rEGfKdgZ7jloTSv+rw4+XiECQgU/uHsgyvNpm0lM2BRLXIbQRPp8r
         rxdHQvcyYXFbk1PgabHQh8xpU3MO98BvXz0BAdWtpimCy7UqymU3xWRdkcCzI/rTwdDm
         XL4bxy8KM6s4WeRBXz97nLc7e9Bb1OWGSbTIQ=
MIME-Version: 1.0
In-Reply-To: <20100119212209.GF3804@infomag.iguana.be>
References: <20100119212209.GF3804@infomag.iguana.be>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 19 Jan 2010 17:48:05 -0500
Message-ID: <8bd0f97a1001191448k70b04ea7u98a6df64d2cc987b@mail.gmail.com>
Subject: Re: [RFC] [PATCH] change reboot_notifier to platform-shutdown method.
To: Wim Van Sebroeck <wim@iguana.be>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thierry Reding <thierry.reding@avionic-design.de>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 16:22, Wim Van Sebroeck wrote:
>    [WATCHDOG] change reboot_notifier to platform-shutdown method.
>
>    Platform device drivers can use the .shutdown method to handle soft
>    shutdown's instead of reboot_notifier's.
>
> --- a/drivers/watchdog/bfin_wdt.c
> +++ b/drivers/watchdog/bfin_wdt.c

seems to work fine on my Blackfin boards:
root:/> dmesg -n 8
root:/> reboot
bfin_wdt_write:222: here i am
bfin_wdt_keepalive:88: here i am
bfin_wdt_release:196: here i am
bfin_wdt_stop:100: here i am
bfin_wdt_shutdown:418: here i am
bfin_wdt_stop:100: here i am
Restarting system.�

and i like things that shrink code:
-   1792     176      20    1988     7c4 drivers/watchdog/bfin_wdt.o
+   1676     164      20    1860     744 drivers/watchdog/bfin_wdt.o

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
