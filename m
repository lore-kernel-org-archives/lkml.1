Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbZBXNxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbZBXNxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbZBXNx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:53:29 -0500
Received: from mail-ew0-f164.google.com ([209.85.219.164]:42611 "EHLO
	mail-ew0-f164.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbZBXNx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:53:29 -0500
X-Greylist: delayed 648 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Feb 2009 08:53:28 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=YgvcFBAPqkQcMLEjGBsGUzEa+xuPo5qA0WYzKbR+8r0nJkaVyrIMTAlSDI4jE25V38
         n9xUoTbNsaPvieTuoJ88oqBpO70Hd7HKlx3dLfEk1oiSZD/BNhL5QuteHBE46kVs13IK
         whE+wnwQ6FaZzfqr5x2tDWVVA9xR2Ax8rlUsg=
MIME-Version: 1.0
In-Reply-To: <f1f3dd8f0902240542m58aa6adfn3fc09cee162636a1@mail.gmail.com>
References: <f1f3dd8f0902221910n2722b024pe3ec8748fd3aed5b@mail.gmail.com>
	 <alpine.LFD.2.00.0902221941510.3111@localhost.localdomain>
	 <f1f3dd8f0902240542m58aa6adfn3fc09cee162636a1@mail.gmail.com>
Date: Tue, 24 Feb 2009 08:53:25 -0500
Message-ID: <f1f3dd8f0902240553j15a4714bte24e9273c702f540@mail.gmail.com>
Subject: Re: pci 0000:01:00.0: BAR 0: can't allocate resource
From: George Rapp <george.rapp@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re-sending; forgot to turn off HTML and lkml bounced my original ...]

On Tue, Feb 24, 2009 at 8:42 AM, George Rapp <george.rapp@gmail.com> wrote:
>
> On Sun, Feb 22, 2009 at 10:50 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> Can you also show the contents of /proc/iomem?
>
> Linus -
>
> Here it is:
>
> [root@newbackend ~]# cat /proc/iomem
> 00000000-0009fbff : System RAM
> 0009fc00-0009ffff : reserved
> 000a0000-000bffff : Video RAM area
> 000c0000-000ccfff : Video ROM
> 000d0000-000d47ff : Adapter ROM
> 000f0000-000fffff : reserved
>   000f0000-000fffff : System ROM
> 00100000-1bffffff : System RAM
>   00400000-006d8200 : Kernel code
>   006d8201-0088aa97 : Kernel data
>   008f8000-009ed14b : Kernel bss
>   01382000-01382fff : Local APIC
> d8000000-e7ffffff : PCI Bus 0000:01
>   d8000000-d801ffff : 0000:01:00.0
> e8000000-efffffff : 0000:00:00.0
> f0000000-f1ffffff : PCI Bus 0000:01
>   f1000000-f100ffff : 0000:01:00.0
> f2000000-f201ffff : 0000:00:0b.0
> f3000000-f307ffff : 0000:00:0c.0
> f4000000-f40001ff : 0000:00:0c.0
>   f4000000-f40001ff : sata_sil
> f4001000-f400107f : 0000:00:0b.0
> ffff0000-ffffffff : reserved
>
>
>
>>
>> It does look like it's this one:
>>
>>        pci 0000:01:00.0: BAR 0: can't allocate mem resource [0xe0000000-0xe7ffffff]
>>
>> and the problem is that the kernel cannot find enough space to map the
>> required 128MB region for the graphics aperture.
>>
>> Which is really odd, because the bridge to that PCI bus#1 is this:
>>
>>        pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
>>        pci 0000:00:01.0:   IO window: 0x9000-0x9fff
>>        pci 0000:00:01.0:   MEM window: 0xf0000000-0xf1ffffff
>>        pci 0000:00:01.0:   PREFETCH window: 0x000000d8000000-0x000000e7ffffff
>>
>> and that prefetch window is _huge_. Certainly big enough to fit BAR 0, but
>> maybe there is something else in it.
>>
>>                Linus
>
>
>
\
