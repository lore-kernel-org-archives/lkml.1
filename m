Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYFISwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYFISwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYFISwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:52:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:2934 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYFISwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:52:24 -0400
Date: Mon, 9 Jun 2008 20:52:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Uli Luckas <u.luckas@road.de>
Cc: linux-kernel@vger.kernel.org, adaplas@gmail.com,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: Frame buffers and early i2c
Message-ID: <20080609205212.4b0f1ba6@hyperion.delvare>
In-Reply-To: <200806091647.42757.u.luckas@road.de>
References: <200806091647.42757.u.luckas@road.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008 16:47:42 +0200, Uli Luckas wrote:
> I am in the process of trying out a display connected to a colibri board's 
> pxa frame buffer device. The display's power supply is switch through i2c.
> 
> In order to use the frame buffer console I have i2c and pxafb compiled in.
> 
> By default, the pxafb driver get's initialized before the i2c bus causing the 
> display power up to fail.
> 
> What do i2c people think about changing the link order here?

Why don't you ask on the i2c mailing list? Cc added.

Personally I have no objection, but dependencies can be tricky so
you'll have to be careful. video is early in the link order at the
moment.

> What do other frame buffer drivers handle the absence of i2c during early 
> boot?

Interestingly enough, they appear to do fine, despite the linking
order. Maybe because i2c_init is a subsys_initcall() while framebuffer
drivers are initialized with module_init()? Then I'm not sure why your
own driver has a problem there.

-- 
Jean Delvare
