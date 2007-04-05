Return-Path: <linux-kernel-owner+w=401wt.eu-S1767183AbXDESFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767183AbXDESFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767185AbXDESFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:05:15 -0400
Received: from web32508.mail.mud.yahoo.com ([68.142.207.218]:47485 "HELO
	web32508.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767180AbXDESFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:05:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=mcx7SdzOmovs54HW8cEoxR5VhesKXuiKQ6a6SOgngubnK6+ud2dS3etxNiIcfipKg7msPlwPVW/eZvk8xoa6lMUd2bqHJ0Z8yamr30H1vfNHP2mvkGVKdmR4bx40awe1mav21IScl4RcDDw7/zxDY2edP3YinNtUfeJ35FohMOA=;
X-YMail-OSG: _BUmjrkVM1mdFoOc7dYeGiNNQVqLhnlwCPuFikgSol9GiWavvB87Zg8P7PhlaIxMECtIouDWkUY8800_BU5q4lOuiYz9JyT9nf9MCW59quYvaiGnSTbcIPuIVXX00w--
Date: Thu, 5 Apr 2007 11:05:10 -0700 (PDT)
From: Pat <patchu1@yahoo.com>
Subject: Re: Invalid operand: kernel BUG at mm/rmap.c:434! and arch/i386/mm/highmem.c:42!)
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704051700240.3137@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <702654.55872.qm@web32508.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Hugh Dickins <hugh@veritas.com> wrote:

> > I'm running kernel 2.6.9-22.ELsmp on dual Xeon
> 
> You'd do better to ask Red Hat support than here.

Thanks for the suggestion. I'll give them a shot too.

> Are the initial BUGs usually of that kind -
> rmap.c:434?

Yes. From the ones I've recorded so far, they all
begin with BUGs on rmap.c:434. 

 
> Do check your RAM (memtest86 overnight), maybe that

I ran memtest86+ (default test) overnight on the
system and it's still going strong, so I hope that
indicates the RAM is okay.

> PG_reserved bit is spurious.  But if rmap.c:434 is
> what's happening to you again and again, I'd wonder
> if a driver has been allocating a high-order page,
> marking the constituent pages as reserved, later
> clearing reserved from the first constituent page,
> then freeing the high-order page while leaving other
> reserved bits behind - I believe that could sneak a
> PageReserved page back into the 2.6.9 allocator.
> 
> If it were a particular application triggering this,
> it'd still be a kernel bug to allow it to happen.

Yes, there is a specific app which seems to be related
to the kernel panic. 

We use a few third party drivers on the system, so my
initial suspicions were on: 3w_9xxx(U) which is the
RAID card driver and fusedriver(U) which is a hardware
PCI card driver. 

The app which is kernel panicing is the only
application which makes use of the fusedriver. I'd
like to confirm my suspicions on the driver. Do you
have any suggestions on how I could trace the kernel
panic to that specific driver?


Thanks again for your input Hugh.


Pat



> > ------------[ cut here ]------------
> > kernel BUG at mm/rmap.c:434!
> > invalid operand: 0000 [#1]
> > SMP 
> > Modules linked in: fusedriver(U) md5 ipv6
> parport_pc
> > lp parport autofs4 i2c_dev i2c_core sunrpc
> > dm_multipath button battery ac uhci_hcd ehci_hcd
> e1000
> > floppy dm_snapshot dm_zero dm_mirror ext3 jbd
> dm_mod
> > 3w_9xxx(U) sd_mod scsi_mod
> > CPU:    5
> > EIP:    0060:[<c01518c6>]    Not tainted VLI
> > EFLAGS: 00010202   (2.6.9-22.ELsmp) 
> > EIP is at page_add_anon_rmap+0xe/0x66
> > eax: 40000964   ebx: c1800040   ecx: 090a100c  
> edx:
> > e5b5a544
> > esi: d1837e8c   edi: fff25508   ebp: c1800040  
> esp:
> > cf12ae40
> > ds: 007b   es: 007b   ss: 0068
> > Process check-enqueued- (pid: 17602,
> > threadinfo=cf12a000 task=f57577b0)
> > Stack: 40002067 80000000 c014d034 fff29000
> 40002025
> > 80000000 00000163 e5b5a544 
> >        f35b9080 00000000 fff25508 fff25508
> 090a100c
> > c014d0e2 cc5a2240 00000001 
> >        090a100c ffffffff ffffffff 00000000
> 00000000
> > 80000000 00000000 00000000 
> > Call Trace:
> >  [<c014d034>] do_anonymous_page+0x19c/0x1db
> >  [<c014d0e2>] do_no_page+0x6f/0x2f9
> >  [<c014d503>] handle_mm_fault+0xbd/0x175
> >  [<c011addb>] do_page_fault+0x1ae/0x5c6
> >  [<c014e58e>] vma_adjust+0x286/0x2d6
> >  [<c014e762>] vma_merge+0xe1/0x165
> >  [<c011d3d5>] finish_task_switch+0x30/0x66
> >  [<c02cf368>] schedule+0x844/0x87a
> >  [<c011ac2d>] do_page_fault+0x0/0x5c6
> >  [<c02d1bab>] error_code+0x2f/0x38
> > Code: 83 7b 10 00 74 0b 89 ca 89 d8 e8 fb fe ff ff
> 01
> > c6 89 d8 e8 ac df fe ff 5b 89 f0 5e c3 56 53 89 c3
> 8b
> > 00 8b 72 44 f6 c4 08 74 08 <0f> 0b b2 01 ce 52 2e
> c0
> > 85 f6 75 08 0f 0b b3 01 ce 52 2e c0 8b 
> 



 
____________________________________________________________________________________
8:00? 8:25? 8:40? Find a flick in no time 
with the Yahoo! Search movie showtime shortcut.
http://tools.search.yahoo.com/shortcuts/#news
