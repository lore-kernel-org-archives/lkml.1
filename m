Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZBLCQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZBLCQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbZBLCQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:16:44 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:39028 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754976AbZBLCQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:16:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yQKQgw47snu05EZr560rABznX7EVJHZe3z6MSgJuVnahT3zKUiJ10DoK35yM+ZE1/LZz8JPx4ADFcGaozAuDVBYveK3v/SPxs2n1O0jYiJQ/WMFH5DGSuCVj3QvVcZl141C4rai0v66f9v1TjthoSuhMRp92nBfu1UQRmxRz5gg=  ;
X-YMail-OSG: KVtXez0VM1nDdA0DRG7TXQshvdBc8dL5.dRFGmL.1hvQitthsRWhFH8lolvJ2ZY.RGC2KNR6YYctMJaXJRICF32j5zGqFYMrkB1Fvo75Hj8nQHNk3H0f.tNvoop0TB58hMW_rJ5jp49H.CbGni6lLOWP
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Joonyoung Shim <dofmind@gmail.com>
Subject: Re: [PATCH] twl4030-gpio: Fix getting the value of the TWL4030 GPIO  output pin
Date: Wed, 11 Feb 2009 18:16:41 -0800
User-Agent: KMail/1.9.10
Cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <4e1455be0902062213o769a4d15ha0c892508839dbad@mail.gmail.com> <200902070000.49089.david-b@pacbell.net> <4e1455be0902090502l554ca462m9c096e359a5b29c3@mail.gmail.com>
In-Reply-To: <4e1455be0902090502l554ca462m9c096e359a5b29c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902111816.41569.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009, Joonyoung Shim wrote:
> but, it doesn't return actual value of the pin if twl4030 GPIO pin is output.

So it would seem that these GPIOs don't support
bidirectional usage.  Documentation/gpio.txt includes:

>>>		However, note that not all platforms can
>>>	read the value of output pins; those that can't
>>>	should always return zero.  

Which is exactly what's happening here, it seems...




> For example, the GPIO13 pin of twl4030 is configured as an output
> using gpio_direction_output() and assigns the GPIO's value to 1
> using gpio_set_value_cansleep(), the result of "# cat /sys/kernel/debug/gpio"
> reports to me as follows.
> 
> GPIOs 192-209, platform/twl4030_gpio, twl4030, can sleep:
>  gpio-205 (keyled              ) out lo
> 
> but it should have reported "hi" instead of "lo".
> 


