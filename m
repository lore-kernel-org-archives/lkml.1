Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZBWVrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZBWVrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 16:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbZBWVrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 16:47:25 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:41994 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZBWVrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 16:47:24 -0500
MIME-Version: 1.0
In-Reply-To: <200902232212.23925.trenn@suse.de>
References: <20090218182822.GA19902@srcf.ucam.org>
	 <20090218190943.GF26802@elte.hu>
	 <9b2b86520902190354m259f85d0n97795da7b1b8afdd@mail.gmail.com>
	 <200902232212.23925.trenn@suse.de>
Date: Mon, 23 Feb 2009 22:47:20 +0100
Message-ID: <ac3eb2510902231347u4ff8e3a4ia69ef3e5c189c756@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Change link order of x86 cpufreq modules
From: Kay Sievers <kay.sievers@vrfy.org>
To: Thomas Renninger <trenn@suse.de>
Cc: alan-jenkins@tuffmail.co.uk, Kay Sievers <kasievers@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       davej@codemonkey.org.uk, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 22:12, Thomas Renninger <trenn@suse.de> wrote:
> On Thursday 19 February 2009 12:54:06 pm Alan Jenkins wrote:
>> On 2/18/09, Ingo Molnar <mingo@elte.hu> wrote:
>> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> >> On Wed, Feb 18, 2009 at 07:31:37PM +0100, Ingo Molnar wrote:
>> >> > Nice fix! Where does this information come from? Distro module
>> >> > ordering magic? It's rather non-trivial.
>> >>
>> >> Pretty much. p4-clockmod is never the preferred option because
>> >> it does no voltage scaling. speedstep-centrino is now almost
>> >> entirely functionally replaced with acpi-cpufreq. The
>> >> powernow-k8 issue was a personal communication from davej.
>> >
>> > I'm wondering whether that priority order should/could be
>> > expressed in the module space too - so that distros wouldnt have
>> > to replicate this. This is really a piece of information the
>> > kernel is best at maintaining.
>>
>> The latest development version of module-init-tools (in the git tree)
>> is designed to preserve the kernel link order when resolving builtin
>> aliases.  If you have two modules which provide the alias "pci:123",
>> they will be loaded in the same order as if they were builtin drivers.
>>
>> It should work if all the cpufreq drivers provide an alias
>> "cpufreq-driver" and userspace just does "modprobe cpufreq-driver".
>> You just need to be sure none of the cpufreq drivers provide *other*
>> aliases which cause them to be loaded earlier, by udev or some other
>> bootscript.
> I wonder whether a "cpu:vendor:fam:model:flags:..." alias makes sense.
> This would solve autoloading of most cpufreq drivers, but it never looked
> important enough.
> Other drivers that could make use of this:
>  - k8temp/k10temp (Don't know about this one, but AFAIK there exists an
>    MSR to read out temperature on latest AMD for which a hwmon driver
>    is/should be written)?
>  - Microcode update?
>  - more?

I thought about something similar, because distros probably do not
want to load all modules shipped with a single alias, but only the
ones match matching the actual hardware.

Unfortunately, the stuff in /sys/devices/system/cpu/ can not be used
to export a modalias until it is converted to proper buses and "struct
device"s.

If we come up with an extensible modalias string, the system boot
scripts can compose, and call modprobe to load cpufreq modules, it
sounds like a good thing to do.

Some day, the properly converted /sys/devices/system/ devices will
work, and can trigger the auto-loading out-of-the-box. If possible,
the modaliases added to the modules could be directly used for the
future system devices.

Thanks,
Kay
