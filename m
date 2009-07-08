Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbZGHKyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbZGHKyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZGHKyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:54:08 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:38576 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZGHKyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ce0YiC4V300inaPECVZbnHse3VRcDSRnU35k3y4NBjsWpDbSGF+yTMQPUEpu8xoZ9E
         AdyS3Y9gXjKARW2wuwgeYug7RJ6pg6CrxMcUgyVfMx+FNG0t6BgC7M7ICskEFNdEAUm3
         /uQtEGf/iFCC0mnfvrf+cJaVjinWyZ23c2JqU=
MIME-Version: 1.0
In-Reply-To: <20090623153928.GA32604@suse.de>
References: <b6a2187b0906222211i4509bc4cu39e9123cba61039a@mail.gmail.com>
	 <20090623144221.GA29593@suse.de>
	 <b6a2187b0906230829k308cb875r7362f184bccb1d6d@mail.gmail.com>
	 <20090623153928.GA32604@suse.de>
Date: Wed, 8 Jul 2009 20:54:04 +1000
Message-ID: <21d7e9970907080354h6949b27va40fb830f612287@mail.gmail.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
From: Dave Airlie <airlied@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
       Peter Jones <pjones@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 1:39 AM, Greg KH<gregkh@suse.de> wrote:
> On Tue, Jun 23, 2009 at 11:29:50PM +0800, Jeff Chua wrote:
>> On Tue, Jun 23, 2009 at 10:42 PM, Greg KH<gregkh@suse.de> wrote:
>> > On Tue, Jun 23, 2009 at 01:11:51PM +0800, Jeff Chua wrote:
>> >> commit cc71329b3b89b4a5be849b617f2c4f151f0b9213 moved USB_DEVICEFS to
>> >> be embedded and marked it as depreciated. Can this be reverted? This
>> >> breaks vmware and those systems not using udev.
>>
>> > vmware now works properly with this fix, and has for over a year or so.
>>
>> vmware is working, but can't detect USB devices.
>
> Odd, what version of vmware are you using?
>
>> > What distro does not use udev or mdev or something like it already and
>> > also does not use an updated libusb?
>> > We need some specifics here please.
>>
>> I'm not using it and have been fine without it all these while, so
>> don't see any gain moving to udev or perhaps it's time to consider ...
>
> If you are running your own custom distro/install, then you should be
> able to select CONFIG_EMBEDDED and then USB_DEVICEFS just fine on your
> own.  But note, that you don't sound like the "normal" user at all :)
>

Okay can we revert this for a better reason? it seems to have unhidden a race
condition on booting some of my machines. I've booted some other machines
with the same USB disk and the same kernel fine. The two machines it so far
has turned up issues on are an AMD 1Ghz Athlon with SIS chipset, the other is
an Intel Celeron CPU with a AMD rc410 chipset.

If I take a stock F11 distro, and build 2.6.31-rc2 on a USB HDD root,
I can't boot
I'm not quite sure if something in the F11 initrd needs usbfs for
something (cc'ed Peter)

The same hang happens if I boot a 2.6.30 kernel with an F11 initrd and
with usbfs turned off.

Also for reference all rawhide kernels fail to boot on the same F11 system.

I haven't tried using a rawhide initrd due to rawhide being a bit
unusable at the moment.

Dave.
