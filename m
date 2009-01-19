Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZASRIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZASRIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZASRIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:08:36 -0500
Received: from relay1.sgi.com ([192.48.179.29]:34954 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751706AbZASRIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:08:35 -0500
Message-ID: <4974B38F.5060503@sgi.com>
Date: Mon, 19 Jan 2009 09:08:31 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86: put trigger in to detect mismatched apic versions.
References: <49704DF6.8040205@sgi.com> <20090116092540.GC4305@elte.hu> <4970C984.30202@sgi.com> <20090116223011.GB3899@elte.hu> <497116A8.5080900@sgi.com> <20090117030752.GB127262@sgi.com> <20090118190849.GB858@elte.hu> <20090118212553.GA164127@sgi.com>
In-Reply-To: <20090118212553.GA164127@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Steiner wrote:
> On Sun, Jan 18, 2009 at 08:08:49PM +0100, Ingo Molnar wrote:
>> * Jack Steiner <steiner@sgi.com> wrote:
>>
>>>> Btw, I checked with our UV architect and the problem is that we need a 
>>>> 16 bit apic id which is what caused the MAX_APICS to be bumped to 32k. 
>>>> The lower 8 bits are the normal apic id, and the upper bit relate to 
>>>> the node.  This means cpu 0 on node 0 has the same apic id as cpu 0 on 
>>>> node 1, etc.  I also asked about whether we could rely on always 
>>>> having
>>> Not strictly true. The apicids in the ACPI tables are always globally 
>>> unique across the entire system. Because of the size of UV systems, UV 
>>> needs 16 bit apicids. This fits in the ACPI apicid id/eid fields.

Ahh, I did mean to say this applied to the lower 8 bits only.
>>>
>>> The actual processor apicid register is unfortunately only 11 bits and 
>>> there are some restrictions on the actual values loaded into the apicid 
>>> register.

This is for x2apics only, yes?

>>>
>>> If we can put unique ids into the apicid register, we do. If we can't, 
>>> the function that reads the apicid will automatically supply the rest of 
>>> the bits.  Most of the kernel is unaware that the processor apicid 
>>> register may have only a subset of the bits that are in the ACPI tables.

>> apicid remapping is something we need/want, so we cannot remove that 
>> array. But it would be nice to offload such properties to the percpu area 
>> instead - is there any reason why that is hard? The local apic is attached 
>> to a CPU in any case. Is there some early init reason that complicates 
>> this?
> 
> I can't think of any reason why it could not be moved into
> the percpu data area. Mike???

WHich array?  There are two now, the x86_cpu_to_apicid and x86_bios_cpu_apicid
that are in the percpu area?  (Maybe it's time to find out why there are two. ;-)

Thanks,
Mike



