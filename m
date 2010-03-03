Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750804Ab0CCTIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:08:11 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61748 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab0CCTIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:08:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tZDLAIL0OBONlTHTtD7MX0kWu01hYk/0MGtz0x6OsHEsGrd0Cc4agC1m+lPEf7WcXp
         IowWgPQzwAV/VCWGXLcG/oWj/eqZ28vIgD2zeA49I6KVB2UnW7CRQ9ufZ4z05x4InXyR
         q59Tc2GbXu7/pIrZkIvMOSJoEEQBsfmxGCnnQ=
Date: Wed, 3 Mar 2010 11:07:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <20100303190753.GB11471@core.coreip.homeip.net>
References: <4B8C1867.7040201@cam.ac.uk>
 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
 <20100303184132.GA11471@core.coreip.homeip.net>
 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 10:52:43AM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 3 Mar 2010, Dmitry Torokhov wrote:
> 
> > On Wed, Mar 03, 2010 at 09:03:16AM -0800, Linus Torvalds wrote:
> > > 
> > > What's the difference between a physical "increase screen brightness" key, 
> > > and a "ambient light sensor"? Absolutely none as far as I can tell.
> > 
> > Because in general ambient light sensor may have nothing to do with the
> > screen brightness. The fact that all current uses are tied to
> > controlling screen brightness is coincidential. You could use it as well
> > to turn on the lights in the kitchen if it is getting too dark...
> 
> But my point is, it acts pretty much like a key on a keyboard 
> _regardless_. 
> 
> Sure, you migth use it to turn up the lights too. But how is that 
> different from having a switch to do the same? Again, it doesn't sound 
> that different from a key to me.

I guess for me the distinction is that the event was not caused by an
action of a human being but by change in environment.

Also, if we decide that input layer is the best place for such devices,
it should not be a key but absolute event, ABS_LIGHT_LEVEL or something.

> 
> > Yes, it is easier, but it is not necessarily the right interface. I
> > still believe in using input layer for human iteraction events, and not
> > as generic transport a-la netlink or uevent. Voltage measurements,
> > network cable presence notifications, ambient light/temperature sensors,
> > and so forth do not belong here.
> 
> The thing is, if the choice is about a whole new subsystem just for some 
> silly light sensor logic, I'd _much_ rather see the much simpler - and 
> more useful - approach of just considering it an input event.
> 
> It happens in the same kind of situations, it has the same kinds of timing 
> issues (ie we're not talking streaming megabytes of data), and it has the 
> same kind of users (ie a lightsensor really would be used along with 
> something that cares about input).
> 
> I agree that that's not true in many other situations. A cable insertion 
> event is about the networking, not about some independent input. The kind 
> of application that cares about network cable presense is _not_ the kind 
> of app that would care about keyboard input. Same goes for voltage.

What about magnetometers, accelerometers and so forth? I still do not
think they are pure input layer devices although it is possible to build
a bridge modules so they could plug into input framework if desired.

> 
> That said, I'm not married to the whole "it has to be input layer". But I 
> _do_ think that it's crazy to start doing new subsystems for every little 
> thing. That way lies madness. 
>

I was hoping IIO would fill the niche of framework for generic data
acquisition devices, regardless of how fast or slow they are.

-- 
Dmitry
