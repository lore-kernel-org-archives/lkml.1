Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbYHNN3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbYHNN3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758954AbYHNN2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:28:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:12020 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbYHNN2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:28:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BQmnzxdHj6+T+5vdFSRdLpSwhI61rUFOWliXdSvTP7LgIJCftjqKiphv3p0bYjlf15
         XJOjQsr3RXFgz+erNTkECwMwK0cmI2VSP5Kg+0KcfIuScp6kj6Pw/qwZ/JtvPsTLYTJ7
         BZg4WR8PDGiePhaDfGJPd2I6e7jQjwRXj5IRo=
Subject: RE: Possible CPU_IDLE bug [WAS: Re: Timer unstability on when
	using C2 and deeper sleep states (Dell Latitude XT)]
From: Milan Plzik <milan.plzik@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1218714014.7111.7.camel@localhost>
References: <1218566008.13866.41.camel@localhost>
	 <1218625125.4304.7.camel@localhost> <1218636980.5250.12.camel@localhost>
	 <7E82351C108FA840AB1866AC776AEC460945BB44@orsmsx505.amr.corp.intel.com>
	 <1218658873.4336.15.camel@localhost>
	 <7E82351C108FA840AB1866AC776AEC460945BFF2@orsmsx505.amr.corp.intel.com>
	 <1218701151.4285.9.camel@localhost>
	 <alpine.LFD.1.10.0808141100100.3243@apollo.tec.linutronix.de>
	 <1218714014.7111.7.camel@localhost>
Content-Type: text/plain; charset=utf-8
Date: Thu, 14 Aug 2008 15:28:27 +0200
Message-Id: <1218720507.4545.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Št, 2008-08-14 at 13:40 +0200, Milan Plzik wrote:
> On Št, 2008-08-14 at 11:00 +0200, Thomas Gleixner wrote:
> > On Thu, 14 Aug 2008, Milan Plzik wrote:
> > >   I tried it just now, is performs a bit better than 2.6.26 (e.g. I
> > > don't get that "press any key unless nothing happens" states), even
> > > reports a bit more reasonable values of wakeups, but the system
> > > sometimes becomes rather slow (e.g. when playing video). I was not able
> > > to compile fglrx driver, so I had to change it to radeon one. And also,
> > > the number of wakeups reported is not very convincing, though, it
> > > changes from 300 to 600 (which is ~ two times the sum of wakeups)
> > > without any reason, and sometimes goes even higher.
> > > 
> > >   I tried to use nolapic_timer option, but it didn't help.
> > 
> > Can you please try "hpet=disable" on the kernel command line ?
> 
>   Looks like this has helped; after cold reboot hpet=disable seems to
> help the system to run properly (on 2.6.26 kernel). I wonder what could
> cause these problems. In the meanwhile I learned that this machine
> doesn't do proper cleanup during reboot -- it seems that state before
> reboot affects the state after reboot, so I should probably do some
> re-testing with cold reboot after each attempt. I guess I tried
> hpet=disable some time ago and after quick reboot it did not work
> properly.

  UPDATE: looks like it doesn't help always. I cold-booted twice, once
hpet=disable didn't help and the timing was messed up, the other time it
seemed to work just correctly. Maybe it's some race condition during
startup, but I was not able to find any substantial difference in kernel
messages emitted during boot, (just little changes like 2401.86 BogoMIPS
processor vs. 2401.88 and similar). 

> 
> > 
> > Thanks,
> > 	tglx
> 
>   Thank you,
> 	Milan

