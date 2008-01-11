Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbYAKURQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbYAKURQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 15:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761615AbYAKURA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 15:17:00 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:16168 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523AbYAKUQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 15:16:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EBGL4WJkiGFiLd9QY50hu6QcaSkuLpVuiozhX/BHOxTOGlsKpOMFPFV7p0dw6wG3Rh26rVYSs7lH4jEOsg5a5FvNVk1EEmqUwYXUHUeRFr1Jb/no3cJU4x7dJ7E5hXEe2ZQgcS8+2YP0LUhq39HJbrttJIR+hznhylZCu31HmFE=
Message-ID: <9e4733910801111216g7dfee16ev72ec3c58e5d6c746@mail.gmail.com>
Date: Fri, 11 Jan 2008 15:16:57 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [i2c] [PATCH 0/5] Version 17, series to add device tree naming to i2c
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080111201550.12abb02c@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071220044136.20091.70984.stgit@terra.home>
	 <20080111095638.775670ed@hyperion.delvare>
	 <9e4733910801110752k57f1fd7crd5f143900fc64f0b@mail.gmail.com>
	 <20080111201550.12abb02c@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/11/08, Jean Delvare <khali@linux-fr.org> wrote:
> Secondly, it promotes OF device names as acceptable aliases. This I
> don't think I agree with. While I see some value in moving the OF name
> -> Linux name translation to the drivers themselves (even though I
> don't see this as a mandatory move either), this doesn't imply that OF
> names should be used as aliases. I don't like the idea that different
> architectures will name the same device differently in a visible way.
> This could easily break user-space code that makes assumptions on the
> device names (libsensors comes to mind.) So, I think that this part
> will need some more discussion.

They're aliases.  On the x86 my e1000 Ethernet driver loads using this
alias name:
"pci:v00008086d00001010sv*sd*bc*sc*i*"
In fact, the e1000 driver has 63 alias names in addition to "e1000"

But it's still the e1000 driver after it is loaded.
jonsmirl@terra:/home/linux/drivers/net/e1000$ lsmod | grep e1000
e1000                 115968  0

Loading a I2C driver with an OF alias name is not going to change the
module name after it is loaded. In fact, once the module is in memory
there's no way to tell what name was used to load it.

OF device names are set by the Open Firmware committee. It is not
reasonable to force the Linux names back into Open Firmware since this
would force the other operating systems using Open Firmware to adopt
the Linux names.

This issue hasn't been visible before since there was a global table
in the PowerPC code mapping all known Open Firmware names into linux
names. Keeping this as a global table doesn't scale. The mapping needs
to be done by each device individually.

>
> --
> Jean Delvare
>


-- 
Jon Smirl
jonsmirl@gmail.com
