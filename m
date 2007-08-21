Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbXHUMVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbXHUMVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbXHUMVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:21:31 -0400
Received: from mx1.ciphirelabs.net ([217.72.114.64]:55066 "EHLO
	mx.dmz.ciphirelabs.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbXHUMVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:21:31 -0400
From: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [linux-usb-devel] why was MODALIAS removed from usb kernel events? [u]
Date: Tue, 21 Aug 2007 14:21:16 +0200
User-Agent: KMail/1.9.6
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
References: <200708171622.05115.aj@ciphirelabs.com> <20070821073656.GA6691@kroah.com> <1187696468.2489.10.camel@lov.localdomain>
In-Reply-To: <1187696468.2489.10.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211421.16800.aj@ciphirelabs.com>
X-Ciphire-Security: plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 21. August 2007 schrieb Kay Sievers:
> The subject says MODALIAS was removed, but I don't think that it ever
> was there for a usb-device event. And sure, it's still there for a
> usb-interface event.
>
> Andreas, do I read this right, you miss:
>   DEVICE, PRODUCT, TYPE
> in the usb-interface event, and they only exist in the usb-device event?
>
> And MODALIAS is not what you miss, and the subject of the mail is
> misleading?

I'm coming from a different side, as I know not much about the kernel 
internals. but if I run "udevmonitor --kernel --environment" and then
plug in some usb device (e.g. my smart card reader):
 - on 2.6.21 there are two events with DEVICE and the second has DEVICE
   and MODALIAS set. thats what I need.
 - on 2.6.22 there are two events: one has DEVICE and one has MODALIAS,
   but neither has both. this breaks openct. 

PRODUCT and TYPE are also missing from the event that has MODALIAS in 2.6.22.

> Note:
> DEVICE only exists when USB_DEVICE_CLASS=y,

yes, I tested with 2.6.22 with that turned on. if setting this to no breaks
openct, then we should not easily deprecate it. instead we first need a 
migration plan, than we need enough time to get a new version of openct to 
every user that works with the new and the old kernel, and only after that is 
done we can deprecate it, suggest to turn it of, and even later remove it.
please keep such a timing, many other parts of the kernel follow these rules
too. Documentation/feature-removal-schedule.txt should be updated to contain
exact information how long we can count on USB_DEVICE_CLASS=y etc.

> because it unfortunately is 
> prefixed with the /proc mount path, which doesn't exist when the /proc
> device node support is not compiled in

I'm fine with that. people have used that one for years, and they still should 
have it. if you suggest people should use /dev/bus/usb instead, we need the 
same plan: migration plan first, enough time to adjust the software and get 
it to the users, then deprecation plan and later a removeal. maybe add an 
entry to feature-removal-schedule.txt too? even if only to let everyone
incl. distribution makers know, that /dev/bus/usb is not an instant 
replacement for /proc/bus/usb, even if it seems so for some software.

> so nothing should depend on the existence of DEVICE. 
well, first I need the migration plan: so far I could depend on it,
please give me the new thing that I can depend on. it needs to work
with old kernels too (something like a 6month to 2year window of kernel,
we shouldn't force people to upgrade and downgrade kernel and other
apps unless it is absolutely necessary).

all discussions I remember ended nowhere: there is no alternative
for the combination of DEVICE and MODALIAS. I tried /dev/bus/usb
and sysfs, but it didn't work out because of timing and race conditions
and other problems you summed up as "there is no sane way" ...
but maybe I got this wrong, so I'm asking once more: DEVICE plus MODALIAS
is working fine for me, but I'm happy to migrate. what is the plan,
what shall I do instead? and what is the minimum kernel and udev etc.
required for this alternative to work? and how long can I count on the
old style still to work?

> Most of the recent distros don't mount or configure 
> usbfs anymore, but use /dev/bus/usb/ device nodes, which can handle
> access control lists for local users.

that would be a huge problem, as I know no alternative to DEVICE with
/proc/bus/usb. the kernel tells me about new /proc/bus/usb devices,
but who tells me about any /dev/bus/usb device? as far as I know: no one.
please correct me if I'm wrong, I would be real happy to migrate to a working 
new solution, if it fixes the problem and gives me time for new adventures.

> Is this patch fixing your problem?

will give it a try and respond later. thanks!

Regards, Andreas
