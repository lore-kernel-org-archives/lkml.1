Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYH3Xjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYH3Xjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 19:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbYH3XjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 19:39:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:61488 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbYH3XjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 19:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jMrjkbTDRxuTmalmKFSVAzi/1Vsnqor5kdIEr2UoUW7qGRBB9agISZhKjeVtBPDeCS
         /6FQgmon+ylIT/Vjmb6rlrcpIZXS8mZh74R62ORWny2p04JzlEegVhaeJjNke0l1QAKV
         arJSRnvwkTmZ7+aSbMSslbr0+u7Mg8bXCj4JE=
Message-ID: <86802c440808301639j137ebef1r1ecadeebd351fc03@mail.gmail.com>
Date: Sat, 30 Aug 2008 16:39:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Jordan Crouse" <jordan.crouse@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808301615450.3290@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
	 <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com>
	 <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>
	 <86802c440808301210u6db1b4e7p4036bdc95db1a601@mail.gmail.com>
	 <alpine.LFD.1.10.0808301214310.3290@nehalem.linux-foundation.org>
	 <86802c440808301314t525d1b75r9afcc73857cf5c79@mail.gmail.com>
	 <alpine.LFD.1.10.0808301539391.3290@nehalem.linux-foundation.org>
	 <86802c440808301550s627dfcb0h7ff8971c8248703a@mail.gmail.com>
	 <alpine.LFD.1.10.0808301615450.3290@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 4:28 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 30 Aug 2008, Yinghai Lu wrote:
>>
>> wait, THAT BAR is 64BIT capable, So kernel should assign 64bit range to it...
>> it request_resource fails...
>
> I don't think we've ever done new allocations in 64 bits. Although looking
> for it, I have to admit that I don't see what would limit us right now.
> There used to be some paths that weren't 64-bit clean, but I think we
> fixed all of those.

would be some corner case...

didn't see anything there.

calling  pcibios_assign_resources+0x0/0x90
request_resource: root: (PCI Bus 0000:01) [fe700000, fe7fffff], new:
(0000:01:00.0) [fe7c0000, fe7dffff] conflict 0
request_resource: root: (PCI Bus 0000:03) [fe900000, fe9fffff], new:
(0000:03:00.0) [fe9c0000, fe9dffff] conflict 0
pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
pci 0000:00:02.0:   IO window: 0x9000-0x9fff
pci 0000:00:02.0:   MEM window: 0xfe700000-0xfe7fffff
pci 0000:00:02.0:   PREFETCH window: 0x000000d8000000-0x000000dfffffff
pci 0000:00:04.0: PCI bridge, secondary bus 0000:02
pci 0000:00:04.0:   IO window: 0xa000-0xbfff
pci 0000:00:04.0:   MEM window: 0xfe800000-0xfe8fffff
pci 0000:00:04.0:   PREFETCH window: disabled
pci 0000:00:06.0: PCI bridge, secondary bus 0000:03
pci 0000:00:06.0:   IO window: 0xc000-0xcfff
pci 0000:00:06.0:   MEM window: 0xfe900000-0xfe9fffff
pci 0000:00:06.0:   PREFETCH window: disabled
pci 0000:00:07.0: PCI bridge, secondary bus 0000:04
pci 0000:00:07.0:   IO window: 0xd000-0xefff
pci 0000:00:07.0:   MEM window: 0xfea00000-0xfeafffff
pci 0000:00:07.0:   PREFETCH window: disabled
pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
pci 0000:00:14.4:   IO window: disabled
pci 0000:00:14.4:   MEM window: 0xfeb00000-0xfebfffff
pci 0000:00:14.4:   PREFETCH window: disabled
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:06.0: setting latency timer to 64
pci 0000:00:07.0: setting latency timer to 64

YH
