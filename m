Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYEOBBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYEOBBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYEOBB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:01:26 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33543 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362AbYEOBBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:01:12 -0400
X-Sasl-enc: yXapaUtltAFSiZRibYCM0GXkI/6Wm73JLicgV2uI7LlZ 1210812557
Date: Wed, 14 May 2008 21:49:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Karol Lewandowski <lmctlx@gmail.com>
Subject: Re: [Bug #10670] BUG: linux-2.6.26-rc1 oops at
	thinkpad_acpi:led_set_status
Message-ID: <20080515004911.GA3415@khazad-dum.debian.net>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.qfG.mv1JIB@chimera> <20080512041753.GA4543@khazad-dum.debian.net> <20080514233037.GB11439@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514233037.GB11439@cs181133002.pp.htv.fi>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Adrian Bunk wrote:
> static int led_set_status(unsigned int led, enum led_status_t ledstatus)
> {
> ...
>         switch (led_supported) {
> ...
>         case TPACPI_LED_OLD:
>                         /* 600e/x, 770e, 770x, A21e, A2xm/p, T20-22, X20 */
> ----->                  led = 1 << led;
>                         rc = ec_write(TPACPI_LED_EC_HLMS, led);
>                         if (rc >= 0)
>                                 rc = ec_write(TPACPI_LED_EC_HLBL,
>                                               led * led_exp_hlbl[ledstatus]);
>                         if (rc >= 0)
>                                 rc = ec_write(TPACPI_LED_EC_HLCL,
>                                               led * led_exp_hlcl[ledstatus]);
>                         break;
> ...
>         if (!rc)
>                 tpacpi_led_state_cache[led] = ledstatus;
> ...                                    ^^^
> }

ARGH.  Thanks.  Will fix ASAP.  This is really one of those cases where
one is "too close to actualy see the picture".

> What happens when you write to tpacpi_led_state_cache[0x80] is 
> undefined, and it's not a surprise that random changes let the
> bug seem to disappear.

Indeed.  Thanks Adrian.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
