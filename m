Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbYI3MgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbYI3MgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYI3Mf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:35:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:43136 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbYI3Mf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:35:58 -0400
Message-ID: <ac3eb2510809300535s1a9a1dk1bd8b1080385e864@mail.gmail.com>
Date: Tue, 30 Sep 2008 14:35:55 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: CD tray closes spontaneously after opening it
Cc: "Tony Vroon" <tony@vroon.org>, linux-kernel@vger.kernel.org,
       "Tejun Heo" <tj@kernel.org>, "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <200809301401.23160.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809301247.05367.elendil@planet.nl>
	 <1222773491.4003.2.camel@localhost>
	 <200809301401.23160.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 2:01 PM, Frans Pop <elendil@planet.nl> wrote:
> On Tuesday 30 September 2008, Tony Vroon wrote:
>> On Tue, 2008-09-30 at 12:47 +0200, Frans Pop wrote:
>> > Since 2.6.27 I've had several times, but not always, that after I
>> > open the CD tray by pressing the eject button it spontaneously closes
>> > after a short delay. The delay varies between ~0 and ~2 seconds.
>>
>> For the record, I had this on my Gentoo system. It turned out that HAL
>> was responsible. (So it may not be a kernel bug at all)
>>
>> Do see this report:
>> http://bugs.gentoo.org/show_bug.cgi?id=230886
>
> Thanks for the link.
>
> It cannot be hal in my case as I've disabled polling by hal for both
> drives using the 'hal-disable-polling' command.
>
> The bug report also mentions udev, but I'm not sure if that's it either
> as the bit in the report is about sr* devices, which is SCSI/SATA and
> the patch linked there is in Debian's udev.
> The udev changelog for Debian has:
> udev (0.125-4) unstable; urgency=medium
>  * 60-persistent-storage.rules: do not run vol_id on media tray open
>    events or the kernel will close the tray again.
>
> Hmm, in Debian unstable /etc/udev/rules.d/60-persistent-storage.rules
> also has:
> # skip removable ide devices, because open(2) on them causes an events loop
> KERNEL=="hd*[!0-9]", ATTR{removable}=="1", DRIVERS=="ide-cs|ide-floppy", \
>                                        GOTO="persistent_storage_end"
>
> I wonder if we've got a simple case of a typo here: ide-cs instead of
> ide-cd? However, there is such a thing as an ide-cs driver (legacy driver
> for PCMCIA IDE/ATA disk cards).
> But it does seem logical that rule should also cover IDE CDs...

This rule is fine, it was only ide-cs, the old pcmcia stuff, that had
these issues.

You might need:
  http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=f755fd5657b619fd27160ad202fc5d773d096e9c

Kay
