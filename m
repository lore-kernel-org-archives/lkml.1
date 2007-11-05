Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbXKEVKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbXKEVKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 16:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXKEVKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 16:10:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55286 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbXKEVKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 16:10:30 -0500
Message-ID: <472F85F2.6040501@zytor.com>
Date: Mon, 05 Nov 2007 13:06:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>	<alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>	<472F5941.2060507@zytor.com>	<alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>	<472F61C8.4040300@zytor.com>	<alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org> <m1pryoa1f6.fsf@ebiederm.dsl.xmission.com> <472F7D8D.8050505@zytor.com> <472F826E.3050008@goop.org>
In-Reply-To: <472F826E.3050008@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Nailing down the interface as hard as possible is a good idea, to
>> avoid tying your hands for the future. 
> 
> Erm, I guess I see what you mean, but it comes to the effect of tying
> your hands now in a specific way, rather than having them tied in an
> unknown way later on...

Sort of.  The problem is you can frequently not

> But I hadn't noticed the 32-bit boot protocol spec go in.  Unfortunately
> it isn't useful for booting a pv Xen guest; I just mailed my comments. 
> I hope we can iterate this to something more generally useful before
> getting too wedded to the current protocol.

I'm not so sure about that.  Xen PV is rather fundamentally a different 
beast, hence the platform field recently added to the protocol.

>    2. Also, Xen reserves the last chunk of the GDT for its own
>       descriptors, and by default boots the guest with the segment
>       registers preloaded with selectors pointing to flat 4G descriptors
>       in this range.  These segments are not a full 4G, since it uses
>       segment limits to protect the hypervisor from guests.  The limits
>       are as large as they can possibly be.  I like to see the boot
>       protocol require that all segments registers are preloaded with
>       large flat 32-bit descriptors, but not require a specific selector
>       value.  I'd happy to require the GDT to be active, so the segment
>       registers can be reloaded with their current values, until the
>       kernel establishes its own GDT.


This is addressed by the "don't reload segments" bit in LOADFLAGS.

	-hpa
