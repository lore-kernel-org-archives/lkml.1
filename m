Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbZKYMFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbZKYMFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758753AbZKYMFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:05:51 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52287 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758752AbZKYMFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:05:50 -0500
MIME-Version: 1.0
In-Reply-To: <200911242223.33206.linux@rainbow-software.org>
References: <200911222201.59471.linux@rainbow-software.org> 
	<200911240829.23067.linux@rainbow-software.org> <ac3eb2510911240057h2d2ca308pfeb9c8a94920d543@mail.gmail.com> 
	<200911242223.33206.linux@rainbow-software.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 25 Nov 2009 13:05:40 +0100
Message-ID: <ac3eb2510911250405j6551150eu4b68261a2e03514f@mail.gmail.com>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Takashi Iwai <tiwai@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 22:23, Ondrej Zary <linux@rainbow-software.org> wrote:
> On Tuesday 24 November 2009 09:57:28 Kay Sievers wrote:

>> Oh, your box has acpi mapped pnp aliases for this device? You can see
>> your ID string somewhere in this list?
>>   grep . /sys/bus/acpi/devices/*/modalias
>>
>> If not, is it in the pnp bus list?
>>   grep . /sys/bus/pnp/devices/*/id
>
> It's listen in the pnp bus only:
>
> $ grep -i 80d6 /sys/bus/acpi/devices/*/modalias
> $ grep -i 80d6 /sys/bus/pnp/devices/*/id
> /sys/bus/pnp/devices/01:01.00/id:PNP80d6
> $ cat /sys/bus/pnp/devices/01\:01.00/id
> RTL8019
> PNP80d6
>
> So the acpi alias was useless (I just copied another entry). This alone works:
> alias pnp:dPNP80d6* ne

I see. Plain upstream udev would not load anything here, as the pnp
bus has no modalias support because of the non-working aliases. We
rely on acpi mapping all the pnp entries. Your system probably runs
the shell script which iterates over the "id" file and calls modprobe
for all it finds in there.

Kay
