Return-Path: <linux-kernel-owner+w=401wt.eu-S1762003AbXJYXK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003AbXJYXK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761520AbXJYXK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:10:28 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:44127 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761199AbXJYXKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gL7bGy6x+eUW8FLiDxY+Hk0FxkNrGrfTxg9VPkAOB196QMJznCkzkuPrvEzFslx+3+llnTOrM6JWpF2fOfE7Zw2C2lc9Fg5vTkvL0T6Ifxx7aRD12IE2ZkHK1lUT3ic75ewycJZbnr44lgus9mfnlPU6w9bfTZdUDYK6hEpoamI=
Message-ID: <1f1b08da0710251610i2b0e1c21g8b68c721d65af756@mail.gmail.com>
Date: Thu, 25 Oct 2007 16:10:24 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: "Joshua Roys" <roysjosh@gmail.com>
Subject: Re: 2.6.23 hang, unstable clocksource?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <19b271a20710161331m35c02a18p6967506ad0a6764c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19b271a20710161331m35c02a18p6967506ad0a6764c@mail.gmail.com>
X-Google-Sender-Auth: fad12d2e4b912bd4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/07, Joshua Roys <roysjosh@gmail.com> wrote:
> I am running a vanilla 2.6.23 kernel and am experiencing (seemingly)
> random hangs.  Below is a piece of dmesg and my kernel config, along
> with a few snippets from /var/log/messages showing a 5 minute hang
> (and another hang, but I wasn't at the computer at that time).
>
> This has happened probably over 10 times all told, now.  The first few
> times I just hard-booted the machine, today I decided to be patient,
> and after 5 minutes it became usable again.

What was the last kernel version you were using that didn't show the issue?
Couple of things to try below:

> dmesg:
> Linux version 2.6.23 (root@orannis) (gcc version 4.2.1 (Gentoo 4.2.1
> p1.0)) #1 Fri Oct 12 16:55:58 EDT 2007
> ACPI: RSDP 000FEC00, 0014 (r0 DELL  )
> ACPI: RSDT 000FCC05, 0040 (r1 DELL    GX280          7 ASL        61)
> ACPI: FACP 000FCC45, 0074 (r1 DELL    GX280          7 ASL        61)
> ACPI: DSDT FFFD060C, 30BF (r1   DELL    dt_ex     1000 MSFT  100000D)
> ACPI: FACS 1F686C00, 0040
> ACPI: SSDT FFFD3808, 00BA (r1   DELL    st_ex     1000 MSFT  100000D)
> ACPI: APIC 000FCCB9, 0072 (r1 DELL    GX280          7 ASL        61)
> ACPI: BOOT 000FCD2B, 0028 (r1 DELL    GX280          7 ASL        61)
> ACPI: ASF! 000FCD53, 0067 (r16 DELL    GX280          7 ASL        61)
> ACPI: MCFG 000FCDBA, 003E (r1 DELL    GX280          7 ASL        61)
> ACPI: HPET 000FCDF8, 0038 (r1 DELL    GX280          7 ASL        61)
> ACPI: PM-Timer IO Port: 0x808
> ACPI: HPET id: 0x8086a201 base: 0xfed00000
> Kernel command line: root=/dev/sda2
> Initializing CPU#0
> Detected 2660.302 MHz processor.
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 64-bit timers, 14318180 Hz
> Calibrating delay using timer specific routine.. 5324.67 BogoMIPS (lpj=10649351)
> CPU: After generic identify, caps: bfebfbff 00100000 00000000 00000000
> 0000451d 00000000 00000000 00000000
> monitor/mwait feature present.
> using mwait in idle threads.
> CPU: Trace cache: 12K uops, L1 D cache: 16K
> CPU: L2 cache: 256K
> CPU: After all inits, caps: bfebfbff 00100000 00000000 0000b180
> 0000451d 00000000 00000000 00000000
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
> CPU: Intel(R) Celeron(R) CPU 2.66GHz stepping 01
> Checking 'hlt' instruction... OK.
> ACPI: Core revision 20070126
> Time: tsc clocksource has been installed.
> Switched to high resolution mode on CPU 0
> Real Time Clock Driver v1.12ac
> hpet_resources: 0xfed00000 is busy
> Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin
> is 60 seconds).
> Hangcheck: Using get_cycles().

Could you disable CONFIG_HANGCHECK_TIMER  in your .config? Just to
make sure it isn't flipping out.

> p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
>
> - I missed this hang, according to /var/log/messages it occured at
> 8:14pm last night (Oct 15)
> - I ran ntpdate here to fix the time, which was off by 65 seconds.
> Oct 16 13:43:01 orannis ntpdate[7326]: step time server 128.10.252.7
> offset -65.263313 sec
>
> Clocksource tsc unstable (delta = 299948628229 ns)
> Time: hpet clocksource has been installed.

Another thing to try: Boot with "clocksource=hpet" and verify that
avoids or triggers the issue. If it triggers the issue does it go away
with "clocksource=acpi_pm"?

thanks
-john
