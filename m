Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbXCSOyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbXCSOyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 10:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbXCSOyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 10:54:32 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50668 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbXCSOyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 10:54:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jaya Kumar <jayalk@intworks.biz>
Subject: Re: Geode cs5530a magic (Was: Re: [PATCH] clean up mach_reboot_fixups)
References: <45F8761F.8010203@goop.org> <200703142342.13639.ak@suse.de>
	<45F8ACE8.5030704@goop.org>
Date: Mon, 19 Mar 2007 08:48:39 -0600
In-Reply-To: <45F8ACE8.5030704@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 14 Mar 2007 19:18:16 -0700")
Message-ID: <m1vegxxpa0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Andi Kleen wrote:
>> On Wednesday 14 March 2007 23:24, Jeremy Fitzhardinge wrote:
>>   
>>> The reboot_fixups stuff seems to be a bit of a mess, specifically the
>>> header is in linux/ when its a purely i386-specific piece of code.  I'm
>>> not sure why it has its config option; its only currently needed for
>>> "geode-gx1/cs5530a", so perhaps whatever config option controls that
>>> hardware should enable this?
>>>     
>>
>> Thanks. Looks good.
>
> It looks like a cs5530a is a PATA driver in drivers/ata/pata_cs5530.c. 
> Seems to me the cleanest fix is to register a reboot notifier in the
> driver and have it do the magic rather than have the special
> mach_reboot_fixups mechanism at all.
>
> Assuming it needs to be done at all...
>
> Alan? Jaya?

I'm guessing rather it is an embedded setup, then a weird pata thing.

If we want to remove crud from this path we should provide a hook like
pm_power_off to handle the reboot case.

This is not the kind of thing that a reboot notifier can be used for.
as: 
a) reboot notifiers don't get called on all paths to machine_emergency_restart.
b) touching those bits looks like they immediately flip the reset line, so
   trigger the reboot immediately.

Eric
