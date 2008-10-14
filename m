Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYJNVDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYJNVDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYJNVDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:03:43 -0400
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:52676 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbYJNVDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:03:42 -0400
X-Greylist: delayed 4174 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 17:03:42 EDT
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Nix <nix@esperi.org.uk>,
       linux-kernel@vger.kernel.org, a.zummo@towertech.it
Subject: Re: pktcdvd -> sysfs warning with 2.6.27
References: <87vdvyngni.fsf@hades.wkstn.nix>
	<20081012181700.GA21072@kroah.com> <87prm4mbgy.fsf@hades.wkstn.nix>
	<20081013214747.GA15765@kroah.com> <m34p3f926s.fsf@telia.com>
	<ac3eb2510810140138u438b3935ia134fe8e5dbb795a@mail.gmail.com>
	<1223976041.5394.6.camel@nga.site>
From: Peter Osterlund <petero2@telia.com>
Date: Tue, 14 Oct 2008 21:53:59 +0200
In-Reply-To: <1223976041.5394.6.camel@nga.site> (Kay Sievers's message of "Tue\, 14 Oct 2008 11\:20\:41 +0200")
Message-ID: <m3d4i32bs8.fsf@telia.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Tue, 2008-10-14 at 10:38 +0200, Kay Sievers wrote:
>> On Tue, Oct 14, 2008 at 7:27 AM, Peter Osterlund <petero2@telia.com> wrote:
>> > Greg KH <greg@kroah.com> writes:
>> >
>> >> Both of those should get "real" majors assigned to them.  It's not ok to
>> >> randomly go grabbing major:minor numbers like this for code that is in
>> >> mainline.
>> >
>> > It's not about random grabbing. It's about getting a dynamically
>> > assigned number. The pktcdvd driver once had static numbers, but at
>> > the time when the driver was merged into the mainline kernel, dynamic
>> > numbers were considered better. Therefore I changed the driver to use
>> > dynamic numbers.
>> 
>> The pktcdvd driver allocates a dynamic block major, which is fine. But
>> doesn't it use the same number, and now not allocated, for the char
>> devices it uses? That looks like something that needs to fixed, right?
>> 
>>   static void pkt_sysfs_dev_new(struct pktcdvd_device *pd)
>>   {
>>     if (class_pktcdvd) {
>>       pd->dev = device_create_drvdata(class_pktcdvd, NULL,
>>                                                 pd->pkt_dev, NULL,
>>                                                 "%s", pd->name);
>
> Something similar to this, with error checking, might be needed. It has
> two independent majors now in block and char:
>   $ grep pkt /proc/devices 
>   251 pktcdvd-char
>   252 pktcdvd

Maybe, but that character device would not be used for anything,
besides creating sub-directories in /sys/class/pktcdvd. The driver
implements a block device, not a character device.

Is it possible to create a custom directory in sysfs corresponding to
a block device? A directory /sys/block/pktcdvd0 is apparently created
automatically, but is it possible to extend that directory with driver
specific data?

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
