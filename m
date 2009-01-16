Return-Path: <linux-kernel-owner+w=401wt.eu-S1763453AbZAPEj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763453AbZAPEj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbZAPEjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:39:48 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:50305 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbZAPEjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:39:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sE72xHY2qz92U9/ZCkVAF0LJTMpUtekaz56qRY0Gq1aVS4I0KS7BZRifbGJJZVUO4X
         aeD63s5YWNVpIJRzK14KGDH6K31WTf4zFPpotJCUlL+n2cjFohU+bCmTMNa9GCkzrYV7
         DalW+e7jj9zBUeHxho1ndLoqzyuO/Dswxp/7g=
MIME-Version: 1.0
In-Reply-To: <86802c440901152031k55bf8e2eu31c8b9658c2216ac@mail.gmail.com>
References: <86802c440901152031k55bf8e2eu31c8b9658c2216ac@mail.gmail.com>
Date: Thu, 15 Jan 2009 20:39:47 -0800
X-Google-Sender-Auth: 1de9f2699f5ba3ca
Message-ID: <86802c440901152039i2021a8b0j3d6797593e05968e@mail.gmail.com>
Subject: Re: kexec fail with e1000 and e1000e
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 8:31 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> [    8.652468] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
> [    8.658896] Copyright (c) 1999-2006 Intel Corporation.
> [    8.680008] e1000 0000:05:01.0: enabling device (0000 -> 0003)
> [    8.685831] vendor=1022 device=7458
> [    8.689314] e1000 0000:05:01.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
> [    8.696184] e1000 0000:05:01.0: enabling bus mastering
> [    8.953642] e1000: 0000:05:01.0: e1000_probe: The EEPROM Checksum
> Is Not Valid
> [    9.863340] /*********************/
> [    9.866829] Current EEPROM Checksum : 0xffff
> [    9.871092] Calculated              : 0xbaf9
> [    9.875354] Offset    Values
> [    9.878230] ========  ======
> [    9.881107] 00000000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    9.887622] 00000010: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    9.894137] 00000020: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    9.900653] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    9.907168] 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    9.913684] 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    9.920200] 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    9.926715] 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    9.933231] Include this output when contacting your support provider.
> [    9.939746] This is not a software error! Something bad happened to
> your hardware or
> [    9.947475] EEPROM image. Ignoring this problem could result in
> further problems,
> [    9.954945] possibly loss of data, corruption or system hangs!
> [    9.960767] The MAC Address will be reset to 00:00:00:00:00:00,
> which is invalid
> [    9.968149] and requires you to set the proper MAC address manually
> before continuing
> [    9.975964] to enable this network device.
> [    9.980053] Please inspect the EEPROM dump and report the issue to
> your hardware vendor
> [    9.988041] or Intel Customer Support.
> [    9.991770] /*********************/
>
> git bisect said following patch is first bad one.
>
> commit 98e6e286d7b01deb7453b717aa38ebb69d6cefc0
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Wed Jan 7 13:10:35 2009 +0100
>
>    PCI PM: Register power state of devices during initialization
>
>    Use the observation that the power state of a PCI device can be
>    loaded into its pci_dev structure as soon as pci_pm_init() is run for
>    it and make that happen.
>
>    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>    Acked-by: Pavel Machek <pavel@suse.cz>
>    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

reverting that patch will make kexec work with e1000 again.

YH
