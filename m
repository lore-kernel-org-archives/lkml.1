Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZJVS1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZJVS1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 14:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZJVS1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 14:27:11 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:34316 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352AbZJVS1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 14:27:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GiBlkXO3b8zTMpOR5x3DBW/Dg4NnTeY0f3ORwKVn/Aa5KnRCjroUBt7G2RGLRer/RS
         O78Uz7cxvtELLE81Dv51aDTpZDQWef1k3CAn7pzdDrMkYLuXsgTsicXFkSadmTw3UASS
         EbSJys1nUZB8RW5I7BMi2AG6C7uJvw+6CGKmE=
MIME-Version: 1.0
In-Reply-To: <20091022174816.GC5325@elf.ucw.cz>
References: <20091006200339.GA1538@ucw.cz> <20091017163627.GB1423@ucw.cz> 
	<f17812d70910200859v6d18e81bs2760d8af1d8da5bf@mail.gmail.com> 
	<f17812d70910220705o9f4a0ddwa22157b59a519350@mail.gmail.com> 
	<20091022174816.GC5325@elf.ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 23 Oct 2009 02:26:55 +0800
Message-ID: <f17812d70910221126k50c4ea7em9d58f6e85db884ae@mail.gmail.com>
Subject: Re: zaurus: cleanup sharpsl_pm.c
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n9MIRM16026926

> Introduce separate set of battery limits for corgi. This fixes> compilation, and the values probably should be subtly different, too.>
[Why I'm receiving this for twice ....?]
Pavel,
Anyway, I was thinkin maybe we need a shared table before thereare real requirements for different machines to have their own?
> Signed-off-by: Pavel Machek <pavel@ucw.cz>>> diff -ur linux-rc/arch/arm.ofic/mach-pxa/corgi_pm.c linux-rc/arch/arm/mach-pxa/corgi_pm.c> --- linux-rc/arch/arm.ofic/mach-pxa/corgi_pm.c  2009-09-10 00:13:59.000000000 +0200> +++ linux-rc/arch/arm/mach-pxa/corgi_pm.c       2009-10-22 19:19:02.000000000 +0200> @@ -35,6 +35,92 @@>  #define SHARPSL_FATAL_ACIN_VOLT        182   /* 3.45V */>  #define SHARPSL_FATAL_NOACIN_VOLT      170   /* 3.40V */>> +static const struct battery_thresh corgi_battery_levels_acin[] = {> +       { 213, 100},> +       { 212,  98},> +       { 211,  95},> +       { 210,  93},> +       { 209,  90},> +       { 208,  88},> +       { 207,  85},> +       { 206,  83},> +       { 205,  80},> +       { 204,  78},> +       { 203,  75},> +       { 202,  73},> +       { 201,  70},> +       { 200,  68},> +       { 199,  65},> +       { 198,  63},> +       { 197,  60},> +       { 196,  58},> +       { 195,  55},> +       { 194,  53},> +       { 193,  50},> +       { 192,  48},> +       { 192,  45},> +       { 191,  43},> +       { 191,  40},> +       { 190,  38},> +       { 190,  35},> +       { 189,  33},> +       { 188,  30},> +       { 187,  28},> +       { 186,  25},> +       { 185,  23},> +       { 184,  20},> +       { 183,  18},> +       { 182,  15},> +       { 181,  13},> +       { 180,  10},> +       { 179,   8},> +       { 178,   5},> +       {   0,   0},> +};> +> +static const struct battery_thresh  corgi_battery_levels_noac[] = {> +       { 213, 100},> +       { 212,  98},> +       { 211,  95},> +       { 210,  93},> +       { 209,  90},> +       { 208,  88},> +       { 207,  85},> +       { 206,  83},> +       { 205,  80},> +       { 204,  78},> +       { 203,  75},> +       { 202,  73},> +       { 201,  70},> +       { 200,  68},> +       { 199,  65},> +       { 198,  63},> +       { 197,  60},> +       { 196,  58},> +       { 195,  55},> +       { 194,  53},> +       { 193,  50},> +       { 192,  48},> +       { 191,  45},> +       { 190,  43},> +       { 189,  40},> +       { 188,  38},> +       { 187,  35},> +       { 186,  33},> +       { 185,  30},> +       { 184,  28},> +       { 183,  25},> +       { 182,  23},> +       { 181,  20},> +       { 180,  18},> +       { 179,  15},> +       { 178,  13},> +       { 177,  10},> +       { 176,   8},> +       { 175,   5},> +       {   0,   0},> +};> +>  static void corgi_charger_init(void)>  {>        pxa_gpio_mode(CORGI_GPIO_ADC_TEMP_ON | GPIO_OUT);> @@ -214,8 +300,8 @@>        .fatal_acin_volt  = SHARPSL_FATAL_ACIN_VOLT,>        .fatal_noacin_volt= SHARPSL_FATAL_NOACIN_VOLT,>        .bat_levels       = 40,> -       .bat_levels_noac  = spitz_battery_levels_noac,> -       .bat_levels_acin  = spitz_battery_levels_acin,> +       .bat_levels_noac  = corgi_battery_levels_noac,> +       .bat_levels_acin  = corgi_battery_levels_acin,>        .status_high_acin = 188,>        .status_low_acin  = 178,>        .status_high_noac = 185,>>> --> (english) http://www.livejournal.com/~pavelmachek> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html>���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
