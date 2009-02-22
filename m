Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbZBVJmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbZBVJmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 04:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbZBVJmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 04:42:09 -0500
Received: from mx0.towertech.it ([213.215.222.73]:36290 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752855AbZBVJmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 04:42:08 -0500
Date: Sun, 22 Feb 2009 10:42:05 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: PCF8583 not detected on RiscPC
Message-ID: <20090222104205.4539d3ef@i1501.lan.towertech.it>
In-Reply-To: <20090222082829.GG16596@n2100.arm.linux.org.uk>
References: <20090221194814.GA24385@n2100.arm.linux.org.uk>
	<20090221204147.GA25408@n2100.arm.linux.org.uk>
	<20090222011936.35b21d6b@i1501.lan.towertech.it>
	<20090222082829.GG16596@n2100.arm.linux.org.uk>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009 08:28:29 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

 
> So, really, I'm not listening to NACKs from anyone for this.  The only
> thing I'll listen to is something _constructive_ to make it work again.
> I'm sure Andrew Morton will back me up on this.

 You never listened to anyone, as far as I can remember. The constructive
 part was where I said I'd be happy to give help.


> Now, we can either totally reorganize i2c-acorn, but that won't be
> acceptable for 2.6.29-rc.

  i2c-acorn is just fine as is, while you might want to change
 it to a platform driver at a later time.


> The problem is that this *is* a regression, and therefore must be fixed
> in 2.6.29-rc.  As I see it, the only sane way to do that is to revert
> the conversion until a proper fix can be done.
> 
> So, please provide constructive suggestions on how to add boardinfo to
> this in a sane way, or we revert PCF8583 back to something which works.

  That's very simple, even if acorn is a bit unstructured. You just
 need to choice a place under arch/arm that you like
 (arch/arm/plat-acorn/ ? ) and place a bit of code called
 by an appropriate initcall. 

  There you write something like that, changing
 the values to match your rtc name and i2c address:

static struct i2c_board_info __initdata nslu2_i2c_board_info [] = {
        {
                I2C_BOARD_INFO("x1205", 0x6f),
        },
};
 
...

   i2c_register_board_info(0, nslu2_i2c_board_info,
                                ARRAY_SIZE(nslu2_i2c_board_info));

 
 Unless I missed something that should be all you need.
    

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

