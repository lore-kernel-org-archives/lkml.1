Return-Path: <linux-kernel-owner+w=401wt.eu-S1761162AbZD1L6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761162AbZD1L6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbZD1L6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:58:25 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:39495 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758953AbZD1L6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:58:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eh5Gvm78qmCfD+Xb9Qr2Y86CVLV3QrlvYNHPmcXljjKVh0K0JYQQ9wRTMrSchW2sgj4AtpkNSLUyZQIqGt5Tdy9A9lmlmGQCuNttsET3g73K4eH+wBciIFkZWwsaN5Ftt2WHZaDvElsaqtMd6/ysiDg6FiMnRzpoLgOQzccOgTw=  ;
X-YMail-OSG: PzbgSeYVM1mRtYX.cf_Zor86eIs6so3l8pqlQVeffY75PDzq7R3MQTOVJMVWwCICXapBEIMLrxhkI1unUe9oTvbqRfrEGU7Up1m4DUQ95Oxfnk6yldfny1WQJ.Yqu.8mL4Ltu4k7I3MXLt7Wz_VkVO.MjsFNhi5109awa6nrOX4KPvf7x_C8I900eGMLLKa8On__SUNTzGCPUcUlcf7xZ0vT1UqUUyaIgkQaDO0pdDqEsylT4A4CQ1Y89ZYTZzwSrCiGYf2uRF0TZTmPhE5uAEwR3XjESX5jSzchlH4kHJeFLOQHVurFD2Q-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [spi-devel-general] [PATCH v2] spi: Add support for the OpenCores SPI controller.
Date: Tue, 28 Apr 2009 04:58:22 -0700
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200904041227.54687.david-b@pacbell.net> <1240916464-4187-1-git-send-email-thierry.reding@avionic-design.de> <20090428111532.GA14422@avionic-design.de>
In-Reply-To: <20090428111532.GA14422@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904280458.23018.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 April 2009, Thierry Reding wrote:
> This second version is pretty much a rewrite.

That happens sometimes...


> Some notes about the most 
> important changes:
> 
>   * uses per-chip states to allow more slaves to use the controller
>     concurrently
>   * rejects invalid device configurations during setup
>   * rejects invalid per-message and per-transfer options
>   * queues messages so that they can be processed one after another
>       - this also provides for a way to handle power-management
>   * omits the spioc.h (and with it the platform data structure):
>       - uses the platform_device.id for the bus number
>       - always uses 8 chipselects because that's the maximum that the core
>         supports

All that sounds good.

 
> I couldn't really find a way to implement per-transfer overrides for the
> word size because the controller simply has no concept of word sizes. Is it
> in such cases still necessary to hardwire the word size to 8 bits?

Is this the http://www.opencores.org/?do=project&who=spi core?
Its summary says "Variable length of transfer word up to 32 bits";
does that mean "configurable when core is synthesized" instead of
truly "variable"?
