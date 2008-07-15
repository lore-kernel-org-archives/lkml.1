Return-Path: <linux-kernel-owner+w=401wt.eu-S1760974AbYGOSku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974AbYGOSku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbYGOSkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:40:37 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:18894 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbYGOSkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:40:35 -0400
Date: Tue, 15 Jul 2008 12:40:34 -0600
From: Alex Chiang <achiang@hp.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 14/14] ACPI: Provide
	/sys/devices/system/cpu/cpuN/deconfigure
Message-ID: <20080715184034.GC10919@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org
References: <20080715023344.2528.1836.stgit@blender.achiang> <20080715023455.2528.16193.stgit@blender.achiang> <487CD918.6060405@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487CD918.6060405@linux.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <ak@linux.intel.com>:
> Alex Chiang wrote:
>> Provide a new sysfs interface for CPU deconfiguration.
>>
>> Since no vendors can agree on terminology for related but slightly
>> different features, provide a method for a platform to implement
>> its own version of what it thinks 'deconfiguring' a CPU might be.
>>
>> Provide an HP-specific CPU deconfiguration implementation.
>
> Why are you ccing this to linux-arch? Dropped.

Hm, sorry.

I thought it would have been weird to send patches 1-13 / 14 to
linux-arch, but not send 14 / 14. Perhaps I should set a Reply-to:
in the future?

> What is the standard status of these new SCFG and ECFG tables?
> Have they been submitted for possible inclusion in ACPI? And is
> there a spec available? I can't say I'm really thrilled with
> having HP specific support in there.
>
> It would be better at least if you could reserve the table
> names and  then drop the HP DMI check. This is needed anyways,
> otherwise the  standard at some point could add different
> ECFG/SCFG tables.

These are not new tables -- they are methods that live underneath
processor objects in the namespace.

Yes, they are specific to HP, but because they are methods, there
shouldn't be any collision with other vendors defining methods
with the same name (with the DMI check).

>> + * After echo'ing 0 or 1 into deconfigure, cat'ing the file will
>> + * return the next boot's status. However, the CPU will not actually
>> + * be deconfigured until the next boot.
>
> Now that seems like weird semantics for a public fixed API.
> What happens when some other vendor adds hot deconfiguration?

Yeah, I'm not totally happy with it either. But I'd like to
clarify -- are you concerned with the name of the interface
(deconfigure) or the "nothing happens until next boot" behavior?

Would it help if I renamed it to "enabled" and had something
like:

	echo 0 > enabled
	echo 1 > enabled
	cat enabled

And then that would map to vendor-specific behavior?

Or is it really the "nothing happens until next boot" thing that
bothers you?

> My feeling is that this seems to be overly specific to your
> BIOS and might better belong into some separate management
> tool. At least until we can define a nice general API for this
> with clear semantics.  

Well, life would be a lot easier if we had a generic way to poke
at ACPI methods, but dev_acpi has been rejected multiple times.
;)

On a more serious note, my fear is that an interface like this is
not going to have agreement / clear semantics for a long time
because one vendor is going to want to call it 'deconfigured' and
another one might want to call it 'disabled' and a third might
want to call it 'puppy_dogs' and they'll all be kinda related but
not exactly the same.

That's why I was going down the road of creating at least one
generic interface, but with vendor-specific semantics.

Calling it 'enabled' might be a better idea.

> For what systems is this anyways?

We have HP ia64 systems shipping today that support this.

Thanks.

/ac

