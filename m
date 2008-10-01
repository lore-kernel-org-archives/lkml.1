Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbYJAJs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbYJAJs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 05:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbYJAJsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 05:48:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39691 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbYJAJsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 05:48:19 -0400
Message-ID: <48E34741.1030608@redhat.com>
Date: Wed, 01 Oct 2008 11:47:45 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
Subject: Re: [Hypervisors] TSC frequency change
References: <1222472815.29886.43.camel@alok-dev1>	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>	 <48E15AC7.2080603@redhat.com> <1222734838.30247.102.camel@alok-dev1>	 <48E1DF2C.9050409@redhat.com> <1222835709.32162.26.camel@alok-dev1>
In-Reply-To: <1222835709.32162.26.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> Hi Gerd,
> 
> As Zach explained, we support a view that, tsc is constant.

Ok, so the guest doesn't have to worry about possible tsc changes when
using that interface.  Should go into the comment documenting the leaf.

> Coming back to the migration problem, as you too acknowledge, migration
> to a host with a different frequency should be seen as a different
> problem. I would be interested in learning about any proposal that you
> may have thought about to handle this.

xen paravirtualized is explained below.

xen full virtualized: dunno.

kvm: provide something else for timekeeping to avoid the tsc trouble
altogether if possible.  hpet, pm_timer, paravirtualized clocksource.
Obviously can't work for all guests though.  paravirtual clocksource
works like the xen one.

cheers,
  Gerd

>>> What special things does Xen do at migration, which would be affected by
>>> this interface ?
>> paravirtualized xen guests have a paravirtual clock.  That is a struct
>> containing three pieces of information: system time, tsc counter for the
>> last system time update, tsc frequency.  The guest gets the current time
>> by reading the system time and adding a delta calculated from current
>> tsc, tsc of last systime update and tsc frequency.  Handling tsc
>> frequency changes is obviously trivial here, just update the field on
>> the next systime update ;)
> 
> Oh nice, that is convenient. 
> 
> Thanks,
> Alok
> 
> 

