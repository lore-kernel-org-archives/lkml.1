Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbZGIBdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbZGIBdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 21:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbZGIBdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 21:33:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395AbZGIBde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 21:33:34 -0400
Date: Wed, 8 Jul 2009 18:33:12 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Airlie <airlied@gmail.com>
Cc: Peter Jones <pjones@redhat.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
Message-ID: <20090709013312.GA4580@suse.de>
References: <20090623153928.GA32604@suse.de>
 <21d7e9970907080354h6949b27va40fb830f612287@mail.gmail.com>
 <4A54A4A6.2060100@redhat.com>
 <4A54A538.3080407@redhat.com>
 <20090708140419.GA20418@suse.de>
 <4A54A938.5030807@redhat.com>
 <20090708145625.GA20690@suse.de>
 <4A54B5C2.9000908@redhat.com>
 <20090708154758.GB20979@suse.de>
 <21d7e9970907081423v6d3830eey227f3d54b10382a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21d7e9970907081423v6d3830eey227f3d54b10382a6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 07:23:23AM +1000, Dave Airlie wrote:
> On Thu, Jul 9, 2009 at 1:47 AM, Greg KH<gregkh@suse.de> wrote:
> > On Wed, Jul 08, 2009 at 11:05:38AM -0400, Peter Jones wrote:
> >> Greg KH wrote:
> >> > On Wed, Jul 08, 2009 at 10:12:08AM -0400, Peter Jones wrote:
> >> >> Greg KH wrote:
> >> >>> On Wed, Jul 08, 2009 at 09:55:04AM -0400, Peter Jones wrote:
> >> >>>> On 07/08/2009 09:52 AM, Peter Jones wrote:
> >> >>>>> On 07/08/2009 06:54 AM, Dave Airlie wrote:
> >> >>>>>
> >> >>>>>> I'm not quite sure if something in the F11 initrd needs usbfs for
> >> >>>>>> something (cc'ed Peter)
> >> >>>>> Not a thing.
> >> >>>> Actually, I take it back.  We do mount usbfs, and we examine
> >> >>>> /proc/bus/usb/devices as a heuristic to try and determine if
> >> >>>> all the devices have been enumerated.
> >> >>> How can you ever know if all devices are enumerated as you don't know
> >> >>> how many devices will be showing up?
> >> >> You don't, that's why I said it's a heuristic.  But basically, we have a
> >> >> timeout, and if the device list doesn't change in that amount of time, we
> >> >> call it done.
> >> >>
> >> >> It's not the best technique ever, but it does work.
> >> >
> >> > Works for what?  Why would you want to delay your boot process like
> >> > this?
> >>
> >> Because otherwise when we actually get to mounting the root filesystem,
> >> the device *isn't yet present*.
> >
> > So this is your solution to the "root fs on usb device" problem?  That's
> > odd that you chose this manner, as it still is not "correct" as has been
> > seen on different bug reports over the years on lkml.
> >
> >> >>>> So that could be related to what you're seeing.
> >> >>> That file is now available in /sys/kernel/debug/usb/devices if you
> >> >>> really need it.
> >> >> Oh, okay.  I can change it to use that then.
> >> >>
> >> >>> But I would think that you do not.
> >> >> Well, we pretty much do until we switch to dracut.
> >> >
> >> > What is dracut and why would it change this?
> >>
> >> It's the replacement for mkinitrd, and it's using hotplug events for
> >> this stuff instead.
> >
> > Ah, good, yes, that is the correct solution.
> >
> >> > As no other distro does this kind of waiting, I'm a bit confused as to
> >> > the need for it.
> >>
> >> Good to know you pay attention to what's going on in the Linux world.
> >
> > Oh, I do, I just don't think you are noticing us making distros now
> > without any initrd, or very stripped down ones, in order to achieve fast
> > boot times.  Look at the moblin images from Intel, or the goblin images
> > from openSUSE to see that happening today.
> >
> > So, back to the original problem here, is usbfs a requirement for Fedora
> > machines to boot properly?  Or has that now been fixed in your repo?
> >
> 
> We can't travel back in time even if we fix it in the repo, we have F10 and
> F11 systems out there that people expect to use.

Agreed.

Can I get an acknowledgment that the version in RawHide is fixed up to
work properly with this, so that I have a baseline on when I can put
this option back in the embedded section?

> I would actually expect this initrd using usbfs predates all the hotplug stuff
> we do it in RHEL5 also,its comes from a time when we had to make stuff
> work with what was available at the time, I'd guess the wheel has been
> reinvented 2-3 times in that era, however usbfs has always worked for us.

That's good to remember.  And to also note that you are relying on an
unreliable thing.

> so when you guys said nobody uses this, you meant SuSE and Ubuntu
> don't use this, not nobody.

"Nobody sane" that is :)

Oh, Gentoo and Mandrake and Debian and Moblin and montavista and
windriver also don't use this, so you all are in the miniority here.

> So I don't think CONFIG_EMBEDDED is correct at least at this point.

Agreed, I'll queue up a patch to revert it.

thanks,

greg k-h
