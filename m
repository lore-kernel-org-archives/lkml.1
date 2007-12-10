Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbXLJKPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbXLJKPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 05:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXLJKOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 05:14:55 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:25304 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752284AbXLJKOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 05:14:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TXZcvoc7CHuL1XyCnKBN6xp0FoaGBn/XZiPrYAJg+iGrzewwwnWfbP5IAydC+xK5s48na50m/M1CJz3TeiFOCfLt5NHPvppinzv+jYuYhTooWyAD2JTkc88UMoij7orNcKHg6evgXbQ+sPztj1JA2VSwMwtKYzeWQQqykZM3jBo=  ;
X-YMail-OSG: Ndydpu8VM1nTXkUGrSUGX8rBf2ci183xmNzEJkSZw3lyqOR1GSiQzD9bOSwtmsTYgIHcmH7sVQ--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [PATCH 2.6.24-rc4-mm 2/2] gpiolib: add Generic IRQ support for 16-bit PCA9539 GPIO expander
Date: Mon, 10 Dec 2007 02:14:52 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       i2c@lm-sensors.org
References: <f17812d70712100143w65898405rd96f460aef621a25@mail.gmail.com>
In-Reply-To: <f17812d70712100143w65898405rd96f460aef621a25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200712100214.52478.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2007, eric miao wrote:
> +config GPIO_PCA9539_GENERIC_IRQ
> +       bool "    Generic IRQ support for PCA9539"
> +       depends on GPIO_PCA9539=y

Also depends on GENERIC_HARDIRQS, right?  (You should let
the Kconfig UI handle indentation, too...)

Seems like doing this for an I2C chip ought to shake loose
some interesting review comments.  :)


> +       help
> +         Say yes here to support the Generic IRQ for the PCA9539 on-chip
> +         GPIO lines.

This somewhat resembles the pcf857x chips in that it only support
pin-changed IRQs (IRQ_TYPE_EDGE_BOTH) in hardware.  Some other I/O
expanders are a bit more flexible.

- Dave
