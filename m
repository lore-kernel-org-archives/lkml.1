Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXKFQvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXKFQvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbXKFQvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:51:18 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:1138 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751156AbXKFQvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:51:17 -0500
Date: Tue, 6 Nov 2007 17:51:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
Subject: Re: [i2c] [PATCH] Fix i2c module parameter permissions for
 read/write
Message-ID: <20071106175114.62284a6c@hyperion.delvare>
In-Reply-To: <9e4733910711040539h5714faeeq6a9985fa5a63963@mail.gmail.com>
References: <9e4733910711032155j1649a3b8u56a59e754d77f61b@mail.gmail.com>
	<20071104105501.380a840a@hyperion.delvare>
	<9e4733910711040539h5714faeeq6a9985fa5a63963@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Sun, 4 Nov 2007 08:39:49 -0500, Jon Smirl wrote:
> I figured out later by inserting printks into the driver that they
> were being set from the command line, but without changing the
> permissions there was no way to read them to verify.  The permissions
> should at least be set to 0444 to allow them to be read.

There's nothing to "verify" - the code works as intended, that's about
it.

> IMHO the I2C_CLIENT_INSMOD macros could use some rework since they use
> side effects to set variables without being explicit about it.

I don't understand what you mean here. Can you please be more specific?

> The real problem was unrelated to this, it was an off by one error in
> the i2c bus numbering code of my embedded processor. That made the
> parameters not work since I was setting them on a different bus.
> 
> Changed to 0444.

I'd rather not do that. The i2c core uses I2C_CLIENT_MODULE_PARM()
extensively and I don't really want to create dozens of additional
sysfs files for no good reason. If you want your own parameter to be
readable (or even writable if it makes sense - you didn't show the
code) I'd rather suggest adding a parameter to I2C_CLIENT_MODULE_PARM()
to let the caller decide what mode the attribute should have, setting
the mode to 0 for all the core parameters.

That being said, this whole set of macros in i2c.h is a complete mess
and with David Brownell's work on the i2c-core, using them should
become less necessary over time. Ultimately I'd be happy to get rid of
them completely.

Thanks,
-- 
Jean Delvare
