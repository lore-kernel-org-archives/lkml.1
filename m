Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbZGHVXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbZGHVXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZGHVX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:23:26 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:59090 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbZGHVXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gzY63A+3ZGUsEBS7PpgLsC2fmY2zB9Bs8MmgFVUwWQKgD+IAYaxFDXgrkTzdkhPgxW
         07qZTk9TmPMlBQXEgp/V3HS4gfeQy9NYD1XF6kuvNEzaKpLhkRcibFe/2zX9FCZAA2xv
         qrvvrJoasnrSfWMsYOdgWvL7HI2uEqQEXuroE=
MIME-Version: 1.0
In-Reply-To: <20090708154758.GB20979@suse.de>
References: <20090623144221.GA29593@suse.de> <20090623153928.GA32604@suse.de>
	 <21d7e9970907080354h6949b27va40fb830f612287@mail.gmail.com>
	 <4A54A4A6.2060100@redhat.com> <4A54A538.3080407@redhat.com>
	 <20090708140419.GA20418@suse.de> <4A54A938.5030807@redhat.com>
	 <20090708145625.GA20690@suse.de> <4A54B5C2.9000908@redhat.com>
	 <20090708154758.GB20979@suse.de>
Date: Thu, 9 Jul 2009 07:23:23 +1000
Message-ID: <21d7e9970907081423v6d3830eey227f3d54b10382a6@mail.gmail.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
From: Dave Airlie <airlied@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Peter Jones <pjones@redhat.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 1:47 AM, Greg KH<gregkh@suse.de> wrote:
> On Wed, Jul 08, 2009 at 11:05:38AM -0400, Peter Jones wrote:
>> Greg KH wrote:
>> > On Wed, Jul 08, 2009 at 10:12:08AM -0400, Peter Jones wrote:
>> >> Greg KH wrote:
>> >>> On Wed, Jul 08, 2009 at 09:55:04AM -0400, Peter Jones wrote:
>> >>>> On 07/08/2009 09:52 AM, Peter Jones wrote:
>> >>>>> On 07/08/2009 06:54 AM, Dave Airlie wrote:
>> >>>>>
>> >>>>>> I'm not quite sure if something in the F11 initrd needs usbfs for
>> >>>>>> something (cc'ed Peter)
>> >>>>> Not a thing.
>> >>>> Actually, I take it back.  We do mount usbfs, and we examine
>> >>>> /proc/bus/usb/devices as a heuristic to try and determine if
>> >>>> all the devices have been enumerated.
>> >>> How can you ever know if all devices are enumerated as you don't know
>> >>> how many devices will be showing up?
>> >> You don't, that's why I said it's a heuristic.  But basically, we have a
>> >> timeout, and if the device list doesn't change in that amount of time, we
>> >> call it done.
>> >>
>> >> It's not the best technique ever, but it does work.
>> >
>> > Works for what?  Why would you want to delay your boot process like
>> > this?
>>
>> Because otherwise when we actually get to mounting the root filesystem,
>> the device *isn't yet present*.
>
> So this is your solution to the "root fs on usb device" problem?  That's
> odd that you chose this manner, as it still is not "correct" as has been
> seen on different bug reports over the years on lkml.
>
>> >>>> So that could be related to what you're seeing.
>> >>> That file is now available in /sys/kernel/debug/usb/devices if you
>> >>> really need it.
>> >> Oh, okay.  I can change it to use that then.
>> >>
>> >>> But I would think that you do not.
>> >> Well, we pretty much do until we switch to dracut.
>> >
>> > What is dracut and why would it change this?
>>
>> It's the replacement for mkinitrd, and it's using hotplug events for
>> this stuff instead.
>
> Ah, good, yes, that is the correct solution.
>
>> > As no other distro does this kind of waiting, I'm a bit confused as to
>> > the need for it.
>>
>> Good to know you pay attention to what's going on in the Linux world.
>
> Oh, I do, I just don't think you are noticing us making distros now
> without any initrd, or very stripped down ones, in order to achieve fast
> boot times.  Look at the moblin images from Intel, or the goblin images
> from openSUSE to see that happening today.
>
> So, back to the original problem here, is usbfs a requirement for Fedora
> machines to boot properly?  Or has that now been fixed in your repo?
>

We can't travel back in time even if we fix it in the repo, we have F10 and
F11 systems out there that people expect to use.

I would actually expect this initrd using usbfs predates all the hotplug stuff
we do it in RHEL5 also,its comes from a time when we had to make stuff
work with what was available at the time, I'd guess the wheel has been
reinvented 2-3 times in that era, however usbfs has always worked for us.

so when you guys said nobody uses this, you meant SuSE and Ubuntu
don't use this, not nobody.

So I don't think CONFIG_EMBEDDED is correct at least at this point.

Dave.
