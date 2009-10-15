Return-Path: <linux-kernel-owner+w=401wt.eu-S1763331AbZJOXak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763331AbZJOXak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763306AbZJOXaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:30:39 -0400
Received: from lucidpixels.com ([75.144.35.66]:45386 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758779AbZJOXaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:30:39 -0400
Date: Thu, 15 Oct 2009 19:30:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Bryan Donlan <bdonlan@gmail.com>
cc: bruce.w.allan@intel.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] Add quirk for ACPI reboots on Intel DP55KG boards.
In-Reply-To: <3e8340490910151605j357b303btb26505a2c04cf2d4@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0910151911490.10951@p34.internal.lan>
References: <alpine.DEB.2.00.0910151655590.4808@p34.internal.lan>  <1255645796-29944-1-git-send-email-bdonlan@gmail.com> <alpine.DEB.2.00.0910151831020.15317@p34.internal.lan>  <alpine.DEB.2.00.0910151852510.8329@p34.internal.lan>
 <alpine.DEB.2.00.0910151855320.3244@p34.internal.lan> <3e8340490910151605j357b303btb26505a2c04cf2d4@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1804336358-1255648492=:10951"
Content-ID: <alpine.DEB.2.00.0910151923120.4721@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1804336358-1255648492=:10951
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.0910151923121.4721@p34.internal.lan>



On Thu, 15 Oct 2009, Bryan Donlan wrote:

> On Thu, Oct 15, 2009 at 6:59 PM, Justin Piszcz <jpiszcz@lucidpixels.com> =
wrote:
>
>> Still no match (and still hangs at reboot)...
>>
>> # cat /usr/src/linux-2.6.31.3/arch/x86/kernel/reboot.c|grep -i intel
>> =A0 =A0 =A0 =A0{ =A0 =A0 =A0 /* Handle problems with rebooting on Intel =
DP55KG */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.ident =3D "Intel DP55KG",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0DMI_MATCH(DMI_SYS_VENDOR,=
 "Intel Corp."),
>>
>> Justin.
>>
>
> Sorry - bear with me a bit here, it's my first time writing quirks for th=
is :)
> Try:
>            DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
>            DMI_MATCH(DMI_BOARD_NAME, "DP55KG"),
>

From=20dmidecode:

BIOS Information
   Vendor: Intel Corp.

I assume you mean:

             DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corp."),
             DMI_MATCH(DMI_BOARD_NAME, "DP55KG"),

Did not work.

Trying your revised suggestion below:

>            DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
>            DMI_MATCH(DMI_BOARD_NAME, "DP55KG"),

Up to build #13 now, trying a reboot, but does not look good...

$ dmesg | grep -i series
$

$ uname -a
Linux p34.internal.lan 2.6.31.3 #13 SMP Thu Oct 15 19:23:31 EDT 2009=20
x86_64 GNU/Linux

Here goes..

Same, all methods fail, :(

Justin.
---1463747160-1804336358-1255648492=:10951--
