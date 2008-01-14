Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbYANN7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbYANN7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYANN7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:59:05 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:14906 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbYANN7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:59:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=aYUQ/h+qSRiWOXqH5T1DhXNJmtQ8PoVbjtGTOgyPDZIiazrx9qCyAExu/OdGKfwgxDR6albaBVTE2OiygmKXsnhYPLN4qJHsTrbMidFNdo+kgqx66FmonHZFR87Cg5uVzYvPZFNkJCQ9LTObgF3Wcyg7ThiEpQoCPtFtZhFQi8A=
From: Balaji Rao <balajirrao@gmail.com>
Organization: NITK
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: HPET timer broken using 2.6.23.13 / nanosleep() hangs
Date: Mon, 14 Jan 2008 19:42:41 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Andrew Paprocki <andrew@ishiboo.com>, linux-kernel@vger.kernel.org
References: <76366b180801130310x57f24cc8s641d3ccb2415524c@mail.gmail.com> <478B5CAF.6010605@ladisch.de>
In-Reply-To: <478B5CAF.6010605@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801141942.41732.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2008 06:29:27 pm Clemens Ladisch wrote:
> Andrew Paprocki wrote:
> > I started debugging a problem I was having with my sky2 network driver
> > under 2.6.23.13. The investigation led me to find that the HPET timer
> > wasn't working at all, causing the sky2 driver to not work properly.
> > Simple example:
> >
> > am2:/sys/devices/system/clocksource/clocksource0# echo hpet >
> > current_clocksource am2:/sys/devices/system/clocksource/clocksource0#
> > time sleep 1
> > <hangs indefinetly...>
> >
> > Running strace shows it blocked on nanosleep(). I'm building the
> > kernel with the processor type set to Athalon64. I've built it with
> > and without SMP and high-res timers enabled and I get the same result.
> > My previous 2.6.18-4 kernel works because it does not install HPET as
> > the default timer. The same behavior occurs in 2.6.24-rc7 git head.
> > I've attached the config/dmesg below.
> >
> > Under 2.6.18-4 (Debian stock kernel):
> >
> > ACPI: HPET id: 0x10b9a201 base: 0xfed00000
> > hpet0: at MMIO 0xfed00000 (virtual 0xf8800000), IRQs 2, 8, 0, 0
> > hpet0: 4 32-bit timers, 14318180 Hz
> > Using HPET for base-timer
> > hpet_resources: 0xfed00000 is busy
> > Time: tsc clocksource has been installed.
> >
> > Under 2.6.23.13 w/ SMP:
> >
> > ACPI: HPET 37FE7400, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD       98)
> > ACPI: HPET id: 0x10b9a201 base: 0xfed00000
> > Time: tsc clocksource has been installed.
> > Clocksource tsc unstable (delta = 500013666 ns)
> > Time: hpet clocksource has been installed.
>
> The lines prefixed with "hpet0:" are missing; apparently, hpet_alloc()
> was never called because hpet_reserve_platform_timers() is disabled
> because CONFIG_HPET is not set.  Try enabling this option.  (CONFIG_HPET
> is in the "Character Devices" kernel config menu.)
>
> That this option would be required to get the platform HPET code to work
> seems like a bug.
>
This doesn't seem to be the issue, as I have not been able to reproduce the bug on my Core 2 system with the same config.
HPET clocksource works fine with only CONFIG_HPET_TIMER.
>
> Regards,
> Clemens
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


