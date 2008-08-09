Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbYHISnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbYHISnh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 14:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYHISn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 14:43:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:48349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbYHISn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 14:43:28 -0400
From: Thomas Renninger <trenn@suse.de>
To: "S K" <nospamnoham@gmail.com>
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Date: Sat, 9 Aug 2008 20:59:47 +0200
User-Agent: KMail/1.9.9
Cc: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Zhao Yakui" <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com> <200808081430.43012.trenn@suse.de> <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
In-Reply-To: <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808092059.47863.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008 08:23:25 pm S K wrote:
> > Try updating the BIOS.
> > I expect your CPU is too new and the BIOS cannot export the correct freq
> > values for the specific CPU yet.
> >
> >      Thomas
>
> The BIOS is already at the latest version :( Is the above comment the
> only possible reason for the issue?

It is very likely.
I did not go through the DSDT table(s) myself, but if this is true:
> According to the online ACPI spec, the BIOS should expose _PCT, _PSS and PPC
> objects if it supports multiple CPU performance states (aka P-states,
> cpufreq).  I ran your acpidump.txt through acpixtract to generate the DSDT,
> and decompiled it using iasl.  It did not contain any of _PCT, _PSS and
> _PPC.

your BIOS does not export basic CPU freq data. The only way to get cpufreq 
working on latest Intel HW is through ACPI and acpi-cpufreq driver.

It may happen that above functions are somewhat hidden in SSDT tables but 
loading and finding the CPU freq functions generally works quite well.

Mark Langsdorf reported some acpi breakage in .27-rc1, this could also be the 
reason.

That a BIOS update is needed for latest CPUs is common. I expect your machine 
is rather new?

There also is a cpufreq list which moved recently, the latest one you should 
post to is this one:
cpufreq@vger.kernel.org

       Thomas
