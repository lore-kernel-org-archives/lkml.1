Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbZAGNYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbZAGNYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZAGNYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:24:41 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:5305 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZAGNYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:24:40 -0500
Date: Wed, 7 Jan 2009 14:24:26 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ed Swierk <eswierk@aristanetworks.com>
Cc: linux-i2c@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       BARRE Sebastien <sbarre@sdelcc.com>
Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
Message-ID: <20090107142426.4be04d4d@hyperion.delvare>
In-Reply-To: <1231177261.13443.20.camel@localhost.localdomain>
References: <1231177261.13443.20.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ed,

On Mon, 05 Jan 2009 09:41:01 -0800, Ed Swierk wrote:
> [Resent to correct linux-i2c address]
> 
> Following up to Sebastien Barre's recent patch, here I go one step
> further, replacing i2c block transfers with SMBus byte transfers.

Please, no. Adding a compatibility quirk may be acceptable, but forcing
everyone to use it instead of the more efficient original code is not
fair.

> Sticking to pure SMBus makes the driver work on our board, which has an
> nVidia SMBus controller driving a DS1339; nforce2 controllers
> unfortunately don't support any flavor of i2c block transfer.

Are you certain the nForce2 controllers can't do it? The i2c-nforce2
driver doesn't implement it, but this doesn't mean the hardware can't
do it. I don't have any datasheet for these chips, but I know their
SMBus implementation is very similar to those of the AMD 8111, and
i2c-amd8111 has support for I2C block reads and writes. I think it
would be worth giving it a try, by copying the i2c-amd8111
implementation into the i2c-nforce2 driver and seeing if it happens to
just work. If it works, that would be more elegant than your proposed
hack to the rtc-ds1307 driver.

> Reading or writing registers repeatedly until they stick is rather
> nauseating but I'm aiming for correctness if not elegance.  I would
> appreciate any suggestions for improvement.

See above.

-- 
Jean Delvare
