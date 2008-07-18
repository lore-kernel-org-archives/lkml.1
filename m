Return-Path: <linux-kernel-owner+w=401wt.eu-S1760416AbYGRXGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbYGRXGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYGRXGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:06:45 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:39166 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYGRXGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:06:44 -0400
Date: Fri, 18 Jul 2008 17:06:42 -0600
From: Alex Chiang <achiang@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 11/14] x86: Populate cpu_enabled_map
Message-ID: <20080718230642.GB20344@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20080715025656.GC15452@ldl.fc.hp.com> <4880F657.8050508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4880F657.8050508@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin <hpa@zytor.com>:
> Alex Chiang wrote:
>> Populate the cpu_enabled_map correctly.
>>
>> Note that this patch does not actually make any decisions based
>> on the contents of the map.
>>
>> However, as the map is presented via sysfs in:
>>
>> 	/sys/devices/system/cpu/
>>
>> It should be populated correctly.
>>
>> There will be a user-visible change under the above directory.
>> cpuN/ entries for firmware-disabled CPUs will now appear, whereas
>> before, they did not due to a check against ACPI_MADT_ENABLED.
>>
>> The cpuN/ entries will be empty, and the online file in the
>> above directory will reflect which CPUs are actually schedulable.
>>
>> Signed-off-by: Alex Chiang <achiang@hp.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>
> From an x86 standpoint this patchset seems reasonable to me.
>
> Acked-by: H. Peter Anvin <hpa@zytor.com>

Thanks Peter. Let me try and rework the patchset according to
Russell's suggestion here:

	http://lkml.org/lkml/2008/7/18/467

That approach seems cleaner to me.

> Obviously, if the sematics of the operations don't make sense
> for other  architectures -- which I will leave up to the
> affected maintainers --  then that should be carefully
> considered if the generic operations can  be done better.

Russell's solution avoids the issue with the ability to #define
the check away for archs that don't care.

cheers,

/ac

