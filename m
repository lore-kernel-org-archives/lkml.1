Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbZFOCBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbZFOCBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZFOCBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:01:25 -0400
Received: from claw.goop.org ([74.207.240.146]:60377 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZFOCBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:01:24 -0400
Message-ID: <4A35AB6C.7090605@goop.org>
Date: Sun, 14 Jun 2009 19:01:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because	there's
 no local APIC
References: <4A329CF8.4050502@goop.org> <20090612201117.GA29923@lenovo>
In-Reply-To: <20090612201117.GA29923@lenovo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/09 13:11, Cyrill Gorcunov wrote:
> just for the record -- this removement has a side effect.
> Imagine I've passed "disableapic" so I expect as many as
> possible apic-related code would not pass thru execution.
> Now we would have (say for IBM Summit)
>
> acpi_parse_madt
>    default_acpi_madt_oem_check
>      summit_acpi_madt_oem_check
>        mark_tsc_unstable
>        setup_summit
>
> Dunno if it harmless or no but it changes kernel behaviour.
> cpu_has_apic cleared if disableapic option (which is early
> param) passed to kernel.
>
> Just a note. Didn't walk thru all ways.
>    

Yeah, that occured to me over the weekend.  Some of those cpu_has_apic 
tests should probably be replaced with explicit tests to see if noapic 
was specified.  I'll go over it with that in mind.

Thanks,
     J
