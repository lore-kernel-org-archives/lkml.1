Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbZLUJ5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbZLUJ5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 04:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZLUJ5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 04:57:52 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54542 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbZLUJ5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 04:57:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Y6pcyiSQprAxmasuhxcYM6AunGYdYDfvSizbq3oQFqJnmvWrxXkLo06VQIZRTJSRsC
         s7IsAQ90bJG+rk+4rCtOrlhSoTfIbFSxzxS1Qd7cHwXKCfNAHIsYn8SVfj6HqLaUCg8n
         DsQbD5BXPSa2tW4YlNgddM5TEt6JLNoS8MfJg=
MIME-Version: 1.0
In-Reply-To: <200912202342.16806.rob@landley.net>
References: <200912202342.16806.rob@landley.net>
Date: Mon, 21 Dec 2009 10:57:49 +0100
X-Google-Sender-Auth: 0804aa92f0216f17
Message-ID: <10f740e80912210157y7b506677q6a40b40435b4634f@mail.gmail.com>
Subject: Re: Why is ARCH m68k hardwired into drivers/net/wan/Makefile?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 06:42, Rob Landley <rob@landley.net> wrote:
> Anyone have an opinion on this?
>
> From drivers/net/wan/Makefile:
>

You cut one important line here:

| ifeq ($(CONFIG_WANXL_BUILD_FIRMWARE),y)

>>ifeq ($(ARCH),m68k)
>>  AS68K = $(AS)
>>  LD68K = $(LD)
>>else
>>  AS68K = as68k
>>  LD68K = ld68k
>>endif

The corresponding Kconfig entry reads:

config WANXL_BUILD_FIRMWARE
        bool "rebuild wanXL firmware"
        depends on WANXL && !PREVENT_FIRMWARE_BUILD
        help
          Allows you to rebuild firmware run by the QUICC processor.
          It requires as68k, ld68k and hexdump programs.

          You should never need this option, say N.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
