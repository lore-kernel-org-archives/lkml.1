Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbZJEPiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbZJEPiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbZJEPiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:38:08 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:55283 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZJEPiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DArPmO8oJ26Ovuwo324Tl4ex5SngJq+jk9ymPqh0yzpEtFJe/SR5y8vzkLSXFCh6kb
         U1k6PkPVQYdWTRzevRYDL9DMbzKI6MrZ4GP5mk1sASZM8QOW4WqmeA6l9f9XElkeex2L
         cUbI8gIylUqtzua/OPqMb1TPq1OoyGZlqRTyA=
MIME-Version: 1.0
In-Reply-To: <4AC939BB.8090600@wasp.net.au>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
	 <68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>
	 <4AC939BB.8090600@wasp.net.au>
Date: Mon, 5 Oct 2009 17:37:29 +0200
Message-ID: <68676e00910050837g2006bfb8j349891504e474a95@mail.gmail.com>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
From: Luca Tettamanti <kronos.it@gmail.com>
To: Brad Campbell <brad@wasp.net.au>
Cc: lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 5, 2009 at 2:11 AM, Brad Campbell <brad@wasp.net.au> wrote:
> Luca Tettamanti wrote:
>> On Sun, Sep 20, 2009 at 10:20 AM, wixor <wixorpeek@gmail.com> wrote:
>>> I have also discovered that dsdt contains description of what is
>>> connected to each it87 input. Maybe it has also some code to access
>>> the chip? In /proc/acpi I can read only one temperature, while the
>>> chip measures three temperatures, fan speeds and voltages. This is
>>> desktop pc with ASUS A8N1-E maniboard, athlon64 and nforce4 chipset.
>>
>> Try the asus_atk0110 driver, it handles the ACPI hwmon interface on
>> Asus motherboards. If it does not work then please send a dump of your
>> DSDT (/sys/firmware/acpi/tables/DSDT).
>
> Vanilla Kernel 2.6.31.1 fails to load it87 on my machine with the same
> messages as posted above.
>
> [71916.534278] it87: Found IT8716F chip at 0x290, revision 0
> [71916.535783] it87: in3 is VCC (+5V)
> [71916.537239] it87: in7 is VCCH (+5V Stand-By)
> [71916.538763] ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI
> region IP__ [0x295-0x296]
> [71916.540365] ACPI: Device needs an ACPI driver
>
> In addition, asus_atk0110 loads but leaves no trace in dmesg when loaded.

That's good ;-) The driver is quiet when everything is ok. You should
see the corresponding entries under /sys/class/hwmon/hwmonN; upgrade
lm-sensor package to version 3.1.1, older versions do not support ACPI
devices.

> Motherboard is an Asus M2N32-WS. DSDT attached.

>From a quick glance it should work. If it doesn't enable
CONFIG_HWMON_DEBUG_CHIP.

Luca
