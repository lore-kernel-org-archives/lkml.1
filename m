Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbZFBCtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbZFBCtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 22:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZFBCtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 22:49:33 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:60987 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755655AbZFBCtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 22:49:32 -0400
From: Frans Pop <elendil@planet.nl>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [SOLVED] Build failure caused by 'cpuidle: makes AMD C1E work in acpi_idle'
Date: Tue, 2 Jun 2009 04:49:30 +0200
User-Agent: KMail/1.9.9
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200906011858.10575.elendil@planet.nl> <20090602010150.GA21166@sli10-desk.sh.intel.com>
In-Reply-To: <20090602010150.GA21166@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906020449.32339.elendil@planet.nl>
X-OriginalArrivalTime: 02 Jun 2009 02:49:33.0655 (UTC) FILETIME=[C269CE70:01C9E32C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 June 2009, Shaohua Li wrote:
> On Tue, Jun 02, 2009 at 12:58:08AM +0800, Frans Pop wrote:
> > $ git describe master
> > v2.6.30-rc7-227-gd9244b5
> >
> > [...]
> > /home/fjp/projects/kernel/linux-2.6/drivers/acpi/processor_idle.c: In
> > function ???acpi_processor_power_verify???:
> > /home/fjp/projects/kernel/linux-2.6/drivers/acpi/processor_idle.c:617
> >: error: implicit declaration of function ???acpi_timer_check_state???
> > /home/fjp/projects/kernel/linux-2.6/drivers/acpi/processor_idle.c: In
> > function ???acpi_idle_enter_c1???:
> > /home/fjp/projects/kernel/linux-2.6/drivers/acpi/processor_idle.c:839
> >: error: implicit declaration of function
> > ???acpi_state_timer_broadcast??? make[7]: ***
> > [drivers/acpi/processor_idle.o] Error 1
> >
> > Reverting the following two commits fixed the error:
> > 87ad57ba cpuidle: makes AMD C1E work in acpi_idle
> > 7d60e8ab cpuidle: fix AMD C1E suspend hang
> >
> > (Second one probably was not needed, but done as it looked related.)
>
> Can't reproduce it here with your config, can you double check please?

Ah, I'm sorry. I see what went wrong here.

For some reason I had a patch from Len that renames those functions in my 
local branch (ACPI: idle: rename lapic timer workaround routines).
Not sure when or why I picked up that patch. I've dropped it now.

Sorry for the noise and inconvenience.

Cheers,
FJP
