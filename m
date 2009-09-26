Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbZIZBr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbZIZBr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 21:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZIZBry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 21:47:54 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:62589 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZIZBrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 21:47:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NHE5AZhnH8QH+v84brXQ1CKgneuPqYZcy4uD6GK4t2yF+d5tsjXRZVHZfMncfTMWXg
         5N5U8dK/EjUzFFbOeKbfibGkilhAOirkYajccUjJg37lnfeQ2uVioeJbaa4M7pz6mtYh
         5Yl7bZepEqFYorj9VJDXmrF7Fzn4hxcIt/VKs=
MIME-Version: 1.0
In-Reply-To: <501db8660909251802hacbaf04wb8dc1734fa523d34@mail.gmail.com>
References: <501db8660909251509i3eb6cb20i74337928e0708410@mail.gmail.com>
	 <200909260051.34541.elendil@planet.nl>
	 <501db8660909251802hacbaf04wb8dc1734fa523d34@mail.gmail.com>
Date: Fri, 25 Sep 2009 18:47:55 -0700
Message-ID: <86802c440909251847p421d6523ra40c59e724d566fb@mail.gmail.com>
Subject: Re: Regression: kernels since 2.6.26 are unusably slow
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Aneurin Price <aneurin.price@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai.lu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 6:02 PM, Aneurin Price <aneurin.price@gmail.com> wrote:

> Hmm. Looking at dmesg for a 'working' kernel includes an interesting part which
> I foolishly forgot to save, saying that the last 512MB of memory is
> inaccessible (I was wondering where that last half-gig had gone :-)). I can go
> and check exactly what it says, but I don't have the energy left for any more
> reboots today. Anyway, that prompted me to try booting with mem=7168 - and that
> makes the problem go away. Perhaps that will shed some light on things.

[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x220000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CDFFF write-protect
[    0.000000]   CE000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 100000000 mask FE0000000 write-back
[    0.000000]   1 base 100000000 mask F00000000 write-back
[    0.000000]   2 base 000000000 mask F00000000 write-back
[    0.000000]   3 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   4 base 0DFF00000 mask FFFF00000 write-through
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled

looks like your MTRR has some problem, and with that WRITE-THROUGH
there, the trimming e820 will not happen

YH
