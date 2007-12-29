Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbXL2KBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbXL2KBQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 05:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbXL2KBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 05:01:06 -0500
Received: from xabean.com ([67.18.92.146]:50736 "EHLO mail.xabean.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbXL2KBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 05:01:04 -0500
X-Greylist: delayed 2863 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Dec 2007 05:01:04 EST
X-HD-DVD-Key: 09f911029d74e35bd84156c5635688c0 (blow me MPAA)
X-Envelope-From: richard@richardharman.com
X-DomainKeys: Sendmail DomainKeys Filter v0.3.0 mail.xabean.com lBT9D9jB004779
DomainKey-Signature: a=rsa-sha1; s=beta; d=richardharman.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:content-transfer-encoding;
	b=km9egeZUVZnF6wD9/VX0Ba59tERDmm4/HElxdduDxnkqokZhLCHT1aR11sWcpPXV2
	n78bDn9C0lzropAkZgvMg==
X-Client-Addr: 72.83.150.24
X-mtfnpy: !!MTFNPY!!
Message-ID: <47760ED5.6060207@richardharman.com>
Date: Sat, 29 Dec 2007 04:09:41 -0500
From: Richard Harman <richard@richardharman.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
References: <47754735.1050009@richardharman.com> <20071229095242.1300e19c@linux360.ro>
In-Reply-To: <20071229095242.1300e19c@linux360.ro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard-Gabriel Munteanu wrote:

> On Fri, 28 Dec 2007 13:57:57 -0500
> Richard Harman <richard@richardharman.com> wrote:
> 
>> I just saw this thread online from someone else who was having
>> problems with an HP laptop -- I believe my laptop falls into this
>> category.
>>
>> The laptop is currently running Fedora Core 8, but I couldn't figure
>> out what kernel that diff was against.  I'm not experienced with
>> git.  Can you give me a few pointers on how to get that patch applied
>> to a kernel tarball?  I'll be more than willing to be your test
>> subject to see how well this patch and whatever future revision of it
>> may work.
>>
>> Richard
> 
> Hi,
> 
> I'll assume you didn't read the thread careful enough, so I have to
> emphasize the fact that this patch won't improve power savings (even
> more, it may actually consume an additional 1-2 Watts). Try it only if
> you need dynticks for another purpose than just saving power (in which
> case, you should wait until a better solution comes up, namely
> LAPIC-less dynticks).

Oh, at the moment I couldn't care less about power savings, I'm more 
interested in simply getting the kernel properly -booting- on this hardware.

Right now, with your patch and the 'noirqdebug' option or disabling nohz 
the system appears to be stable.  This laptop otherwise locks up trying 
to configure apic/lapic, or locks up solid later with NO oops/bug and 
nothing will bring it out of it (eg, sysrq has no effect).  NMI watchdog 
was also inoperable, which I believe was due to the apic/lapic being 
disabled.

With your patch, the lapic is used:

ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)

These kernel dmesg logs are hand-transcribed, and are from 2.6.22.5, but 
this shows where the kernel would lock up good and solid:

http://www.richardharman.com/pavilion/2.6.22.5/dmesg.txt

> IIRC, the diff was made against 2.6.24-rc4, but it applies okay on the
> latest -rc (2.6.24-rc6 as of now) as far as I can see. Copy starting
> with the line below "---" all the way to the end and save it to a file
> (make sure tabs don't get messed up), then apply with "patch -p1" as
> you would apply any other patch. Run "make xconfig" (or whatever
> interface to Kconfig you use), make sure "Processor type and
> features -> Disable C1E on AMD systems to make dynticks work" is set,
> along with all other relevant options, then build and the kernel as
> usual.

Yeah, I actually found a how-to on how to pull down Linus's git tree, 
and managed to patch -p1 against that.  Kudos to the folks who set up 
faqs on using git.

Anyway, I'm extremely open to getting to the bottom of working around 
the quirks on this hardware.  If I havn't mentioned it previously, this 
laptop is an HP dv6408nr, with an amd turion tl-56 cpu and nVidia MCP51 
chipset.

What can I do to help?  It has been pulling teeth trying to get to the 
bottom of this.
