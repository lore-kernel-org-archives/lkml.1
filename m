Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZG1NzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZG1NzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 09:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbZG1NzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 09:55:18 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:41153 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbZG1NzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 09:55:17 -0400
Message-ID: <4A6F033B.7030302@mnementh.co.uk>
Date: Tue, 28 Jul 2009 14:55:07 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> Add support for tmio_mmc hardware configurations, that lack the cnf io 
> area, like SuperH SoCs. With this patch such hardware can pass a single 
> ctl io area with the platform data.

NAK

I dont like this approach - although it involves minimal changes to the 
driver, it will leave people puzzling over why their accesses to the cnf 
registers do nothing when debugging.

The cnf area is basically clock and power control for devices that have 
it. If I had known of the existence of other tmio devices that didnt do 
it that way when I wrote the driver, it would never have been put in 
there directly.

The *right* way to do this is to use the clk API for clocks and provide 
a small API for power control that the driver will use, if present.

If people want to change the situation in TMIO re: clocks, as I have 
said before, they should start a discussion on how to adapt the clk API. 
  so that more than just the CPU can use it. This will make everyone 
happy all in one go.

I will happily take a patch abstracting power control from tmio-mmc, 
however.

-Ian
