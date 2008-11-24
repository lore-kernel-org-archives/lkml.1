Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYKXPNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYKXPNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYKXPN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:13:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYKXPNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:13:25 -0500
From: Thomas Renninger <trenn@suse.de>
To: Tom Hughes <tom@compton.nu>
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
Date: Mon, 24 Nov 2008 16:13:24 +0100
User-Agent: KMail/1.9.10
Cc: Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1227454026.7262.59.camel@localhost> <492A7632.4040106@compton.nu>
In-Reply-To: <492A7632.4040106@compton.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811241613.25557.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 November 2008 10:38:58 am Tom Hughes wrote:
> Cristiano Prisciandaro wrote:
> > From: Cristiano Prisciandaro <cristiano.p@solnet.ch>
> >
> > The bios of the eeepc 900 exposes an acpi method that allows clocking
> > the cpu to 630/900 MHz. This driver allows controlling the frequency
> > switch through the cpufreq subsystem.
>
> I should perhaps add at this point that I have an alternative patch
> based on Cristiano's code, which adds this cpufreq driver to the
> existing eeepc-laptop module rather than creating a separate module for it.
>
> Personally I'm quite happy with either solution so I'll leave it to you
> to decide what is the best way to go, but my patch is available if you
> want it.
Either way, shouldn't you be able to provide a dmi matching module alias:
MODULE_ALIAS("dmi:...")
for autoloading?

Or are these two cpufreq functions part of an ACPI device you could match for, 
then it should get an ACPI driver?
If this ACPI device provides more functions, then these should probably also
be added to this driver.
Splitting the OS drivers the same way as BIOS splits up functionality into
ACPI devices is a good idea.

Could you paste at least the whole ACPI device in which:
#define ASUS_CPUFV_READ_METHOD   "CFVG"
#define ASUS_CPUFV_WRITE_METHOD  "CFVS"
sit or better point to an acpidump/dsdt output.

     Thomas



