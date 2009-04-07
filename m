Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbZDGUUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbZDGUUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbZDGUUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:20:32 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:43073 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbZDGUUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:20:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Gi4rouYHrhor0EsBCXv31VBsD/RAU/BAcuJItOGqvB5X/KNkGKXPTE2aMwkXk0K3wE
         HDYXKZSEz8f70mAOBZ+t9MJ7WgYgjSEANaV8JEJiE4rAPOY0xSzXRXRkxB2z43JLqpcA
         alastTuZZv2/yWw+SepmW2xP9RSnyR1a5IYos=
MIME-Version: 1.0
In-Reply-To: <20090328213950.1c788471@hyperion.delvare>
References: <20090328213950.1c788471@hyperion.delvare>
Date: Tue, 7 Apr 2009 22:20:29 +0200
X-Google-Sender-Auth: b74ccba30d18bccc
Message-ID: <10f740e80904071320t2fdd073bs51f3a8abf0f60e36@mail.gmail.com>
Subject: Re: [GIT PULL] i2c updates for 2.6.30
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux I2C <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 22:39, Jean Delvare <khali@linux-fr.org> wrote:
> Please pull the i2c subsystem updates for Linux 2.6.30 from:

> Wolfram Sang (4):
>      i2c-algo-pca: Rework waiting for a free bus

This one introduced:

drivers/i2c/algos/i2c-algo-pca.c:197: warning: 'state' is used
uninitialized in this function

Probably

        while (pca_status(adap) != 0xf8) {

should become

        while ((state = pca_status(adap)) != 0xf8) {

again.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
