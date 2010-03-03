Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0CCSln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:41:43 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34485 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0CCSll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:41:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YfctXbx2OkO1I60/a5R16WsxYCyekhjKifXXW3dMHZWi9FxNESUIfqxzwAUZbg5gGT
         IxYtpw3Ts1cWG0AGLWjUB+Dr50sjnEAa1YPn/QPg5jzymGJhzncnemkc1g/JBfiEtAva
         ydjdzyeZialh48we7SMBZtDm4T2AhsPaOiK08=
Date: Wed, 3 Mar 2010 10:41:32 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <20100303184132.GA11471@core.coreip.homeip.net>
References: <4B8C1867.7040201@cam.ac.uk>
 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 09:03:16AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 2 Mar 2010, Dima Zavin wrote:
> > 
> > I definitely see the need for what you guys are trying to accomplish.
> > For example, currently, we use an input device for reporting events,
> > and a separate misc device node for control
> > (enable/disable/configure). It's definitely suboptimal, but there
> > currently isn't anything there would let us do things cleanly.
> 
> I have to say, I personally don't see why something like an ambient light 
> sensor _isn't_ just an input device. 
> 
> What's the difference between a physical "increase screen brightness" key, 
> and a "ambient light sensor"? Absolutely none as far as I can tell.

Because in general ambient light sensor may have nothing to do with the
screen brightness. The fact that all current uses are tied to
controlling screen brightness is coincidential. You could use it as well
to turn on the lights in the kitchen if it is getting too dark...

> 
> And for something like an X server, it sounds a lot more natural to just 
> have another input device than to have yet abother event reporting 
> interface.
> 

Yes, it is easier, but it is not necessarily the right interface. I
still believe in using input layer for human iteraction events, and not
as generic transport a-la netlink or uevent. Voltage measurements,
network cable presence notifications, ambient light/temperature sensors,
and so forth do not belong here.

-- 
Dmitry
