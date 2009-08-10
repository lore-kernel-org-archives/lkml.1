Return-Path: <linux-kernel-owner+w=401wt.eu-S1751039AbZHJGVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039AbZHJGVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 02:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZHJGVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 02:21:48 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:47964 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZHJGVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 02:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fZCBr76C+yAXHQDk0arlUD7ygvSWxde5w2Gil6Yd3x9dy1WASLtg0Mbj6za18zM+e5
         jhyoSsnYjI5WMWR60AMOqu1S6NbsDL5YxLMJjGCP+qM2uaLh1YQILsWgBud4KhrT119w
         d1uzHSwXslggrc6AbCBaR/evhug37Drw1wR08=
MIME-Version: 1.0
In-Reply-To: <1249369794.9324.18.camel@macbook.infradead.org>
References: <3877989d0907310129p29dd5039p18563946b9be8099@mail.gmail.com>
	 <1249369794.9324.18.camel@macbook.infradead.org>
Date: Mon, 10 Aug 2009 14:21:48 +0800
Message-ID: <3877989d0908092321h56afcc7ve9fe39fa68f42a48@mail.gmail.com>
Subject: Re: [RFC patch] return early if all dmar HW unit ignored
From: Luming Yu <luming.yu@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Sorry for late response.. I tried your patch that terminates dmar
table init if "one
DMAR reported at address xxxxx returns all = ones"
I know BIOS is very likely to do bad things, so I think your patch makes sense.
But I think the following info should look better..

Instead of ending up in parse DMAR table failure right after just one
drhd record,
all 4 are parsed. ( I applied your patch and the patch of this thread,
and changed your patch to set ignored flag)

$ dmesg | grep -i dmar
[    0.000000] ACPI: DMAR 000000007d2c225f 001A8 (v01 COMPAQ BEARLAKE
00000001      00000000)
[    0.161030] DMAR:Host address width 36
[    0.161032] DMAR:DRHD base: 0x000000fed90000 flags: 0x0
[    0.161045] WARNING: at drivers/pci/dmar.c:640 alloc_iommu+0xfc/0x230()
[    0.161049] Your BIOS is broken; DMAR reported at address fed90000
returns all = ones!
[    0.161070]  [<ffffffff81819ce9>] dmar_table_init+0x1b1/0x35a
[    0.161119] DMAR:DRHD base: 0x000000fed91000 flags: 0x0
[    0.161127] WARNING: at drivers/pci/dmar.c:640 alloc_iommu+0xfc/0x230()
[    0.161130] Your BIOS is broken; DMAR reported at address fed91000
returns all = ones!
[    0.161146]  [<ffffffff81819ce9>] dmar_table_init+0x1b1/0x35a
[    0.161183] DMAR:DRHD base: 0x000000fed92000 flags: 0x0
[    0.161191] WARNING: at drivers/pci/dmar.c:640 alloc_iommu+0xfc/0x230()
[    0.161194] Your BIOS is broken; DMAR reported at address fed92000
returns all = ones!
[    0.161210]  [<ffffffff81819ce9>] dmar_table_init+0x1b1/0x35a
[    0.161247] DMAR:DRHD base: 0x000000fed93000 flags: 0x1
[    0.161255] WARNING: at drivers/pci/dmar.c:640 alloc_iommu+0xfc/0x230()
[    0.161258] Your BIOS is broken; DMAR reported at address fed93000
returns all = ones!
[    0.161274]  [<ffffffff81819ce9>] dmar_table_init+0x1b1/0x35a
[    0.161310] DMAR:RMRR base: 0x0000007d600000 end: 0x0000007dffffff
[    0.161313] DMAR:RMRR base: 0x0000007d2d0000 end: 0x0000007d2d0fff
[    0.161315] DMAR:RMRR base: 0x0000007d2d1000 end: 0x0000007d2d1fff
[    0.161318] DMAR:RMRR base: 0x0000007d2d2000 end: 0x0000007d2d2fff
[    0.161320] DMAR:RMRR base: 0x0000007d2d3000 end: 0x0000007d2d3fff
[    0.161322] DMAR:RMRR base: 0x0000007d2d5000 end: 0x0000007d2d5fff
[    0.161325] DMAR:RMRR base: 0x0000007d2d6000 end: 0x0000007d2d6fff
[    0.161327] DMAR:RMRR base: 0x0000007d2d7000 end: 0x0000007d2d7fff
[    0.161329] DMAR:No ATSR found
[    0.161370] IOMMU: all dmar HW unit ignored


But I don't know why I were seeing faults if all dmar units were
ignored? Surely that
shouldn't happen? Will double check and investigate.

Thanks,
Luming


On Tue, Aug 4, 2009 at 3:09 PM, David Woodhouse<dwmw2@infradead.org> wrote:
> On Fri, 2009-07-31 at 16:29 +0800, Luming Yu wrote:
>> Hello list,
>>
>> When debugging an IOMMU problem, I noticed it should be much more safe
>> to return early than late if all remapping HW unit are ignored.
>> To figure out what device causes the iommu problem on my linux box:
>> hp-compaq dc7800, I tried to mark all dmar HW
>> unit ignored,but still got a lot of unxepcted dmar_fault. So I think
>> the proposed patch make sense. The next step is to
>> add a boot option to make dmar HW units selectable enable/disable individually.
>
> Why were you seeing faults if all dmar units were ignored? Surely that
> shouldn't happen?
>
> This patch doesn't make a lot of sense on its own -- can you show what
> you were intending to do as the 'next step'?
>
> --
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
>
>
