Return-Path: <linux-kernel-owner+w=401wt.eu-S1761575AbYFDSgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575AbYFDSgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYFDSgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:36:07 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:52298 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYFDSgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hoADxvkmN1jVJye9wT7DTmCHdXBWb4AT8p1RQ77nSL1Y3HbEsKVDeDVqwfq4+92Uth
         10YA9INDWX3kRrqCDv+3lIQm/usB05RvtS8NHHg1bR92Sr10JzpiUQRdpRyBIGCP4qzM
         zdUOaWpDeRc7Jgp/NJOlXnDucMd0LqxFeySvU=
Message-ID: <cd73a99e0806041136o2a9ee520q28752af9b6290644@mail.gmail.com>
Date: Wed, 4 Jun 2008 20:36:05 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: AT91SAM9/CAP9 watchdog driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>, wim@iguana.be,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080604123642.51449a04@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cd73a99e0806010940g501f11b4jcb7caf6acfd5c49f@mail.gmail.com>
	 <20080603142316.c53b32b2.akpm@linux-foundation.org>
	 <cd73a99e0806040031s13e6b4a5ndc5fb3d931e1945f@mail.gmail.com>
	 <20080604123642.51449a04@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Alan,

>> Since the watchdog registers are Write-Once, if the user does not
>> specify a "wdt_timeout" parameter we'd still like the driver to load
>> even if it's not enabled.
>
> Surely you can avoid doing the register writes until after you check the
> validity of arguments ?

The validity of the timeout value is checked in at91_wdt_settimeout().
 It returns -EINVAL if the timeout value is invalid.

The issue above is rather that probe() should not fail if
at91_wdt_settimeout() returns -EINVAL, since we'd like the
driver/module to still load to allow the user to later specify a valid
timeout via ioctl(WDIOC_SETTIMEOUT).


Regards,
  Andrew Victor
