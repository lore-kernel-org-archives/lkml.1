Return-Path: <linux-kernel-owner+w=401wt.eu-S1760923AbYHUSbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923AbYHUSbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYHUSbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:31:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39333 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbYHUSbW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:31:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Bug #11313] Plugging HDMI causes "unable to handle kernel paging request"
Date: Thu, 21 Aug 2008 20:34:37 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Jack Steiner <steiner@sgi.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickens <hugh@veritas.com>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <b170af450808201327q48b5b2e0n319c89b0fc1759b6@mail.gmail.com> <48ADB041.9040806@goop.org>
In-Reply-To: <48ADB041.9040806@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808212034.38792.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of August 2008, Jeremy Fitzhardinge wrote:
> Rafał Miłecki wrote:
> > I added full dmesg 5 minutes after adding grepped:
> > http://bugzilla.kernel.org/attachment.cgi?id=17331
> >   
> 
> OK, I think I see the problem (pasted from bugzilla comment):
> 
> >>>>
> Some notes as I pick through all the evidence so far:
> 
> - the crash is specifically because there are reserved bits set in the pmd
> - the pmd is b02a00043a6001a3 in both cases
> - the vaddr is ffff88013a600000 in the first crash, and
>                ffff81013a6d1c00 in the second
>   corresponding to the same large-page pmd mapping of phys page 0x13a600000
> - this maps to e820 entry
>  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
> - the corresponding boot-time mapping is
> 
> init_memory_mapping
>  0100000000 - 0140000000 page 2M
> kernel direct mapping tables up to 140000000 @ b000-11000
>                                                ^^^^^^^^^^
> addr 100000000 reusing pgd 201880 0000000000202063
> last_map_addr: 140000000 end: 140000000
> 
> !!! and the memory allocated for this pagetable is:
>   #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
>   #6 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
>                                                      ^^^^^^^^^^^^^^^^^^^^^^^
> 
> IOW, it's mapping using b000-11000, but it has only reserved b000 - c000
> 
> Also, this is right in the middle of the ISA area, which seems risky.
> <<<<
> 
> Bug #11237 shows the same symptom, so I'm pretty confident they're dups now.

I have marked #11313 as a duplicate of #11237.  Please use the latter one from
now on.

Thanks,
Rafael
