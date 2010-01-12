Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227Ab0ALTT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0ALTT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690Ab0ALTT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:19:26 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53353 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0ALTTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:19:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=I00LOQPexLep/1xofM2YE1mVKyZan77eRaK06BVg9FHEb96jTlarx115KL5Rtlti9g
         DqTuUcZb1BR2lBDJAtZzZaDDhl+FxDvz7ozKbP0uxhCFnCZf0zEsZ7ea9T0Wffii5KHD
         BKT+WHRQdjh0zE1Effzi6CciJgBemimx2xOzc=
MIME-Version: 1.0
In-Reply-To: <1263320647.2854.295.camel@sbs-t61.sc.intel.com>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
	 <1263264483-3959-4-git-send-email-yinghai@kernel.org>
	 <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain>
	 <86802c441001120059s46a2e93aydc76067960aa07e6@mail.gmail.com>
	 <alpine.LFD.2.00.1001120719260.17145@localhost.localdomain>
	 <86802c441001121013o4b8775edl1bc36f120e072b75@mail.gmail.com>
	 <1263320647.2854.295.camel@sbs-t61.sc.intel.com>
Date: Tue, 12 Jan 2010 11:19:25 -0800
X-Google-Sender-Auth: 68bf0f81177d84ea
Message-ID: <86802c441001121119sc779437if93fbbb81482c48f@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] x86: use dmi check to treat disabled cpus as 
	hotplug cpus.
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 10:24 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Tue, 2010-01-12 at 10:13 -0800, Yinghai Lu wrote:
>> ok let stay with option 1.
>>
>> and would like to use DMI to blacklist those systems that do need treat disabled
>> cpus MADT as hotplug cpus.
>
> Yinghai, I don't think we have to worry about disabled cpu's etc using
> DMI etc. If we really come across such a system, they can use ACPI FADT
> flags (ACPI_FADT_APIC_PHYSICAL) to specify that they need to use
> physical mode.

i want other way.

1. after use nr_cpu_ids instead of num_processors to decide if we need
switch to physflat.
some systems that disabled cpus entries that will use physflat even
those system doesn't support
CPU hotplug and could use logical flat.
2. those systems are several model (2 sockets or 4 sockets or 8
sockets) but share one BIOS, and BIOS guys are
 too lazy to remove the disabled entries.
3. so I want to use DMI list to state that those system doesn't need
to treat those disabled cpu as hot plug cpu.
   then we could use logical flat with them.

YH
