Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab0CBWwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:52:12 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:59932 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab0CBWwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:52:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MIxQXPDu4woMnG/nWxEdwRJLP7gyec51BpHzjanKt2UzRVPq3m58VxQKnVX7qPQvVJ
         OK9RsRQ2b+SwoXBeETndWuVnOjXuvTORsfTMuRb8EYcKHz6b5a8GgxKKk0kT7R+q7PAu
         CYwed6e5gZhUCVHphorZrT35OMePYr+9ZlGow=
Date: Tue, 2 Mar 2010 14:51:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Oops while booting 2.6.34-rc0 (block pull busted)
Message-ID: <20100302225159.GD13499@core.coreip.homeip.net>
References: <201003011615.31709.dmitry.torokhov@gmail.com>
 <20100302075656.GO5768@kernel.dk>
 <20100302081547.GP5768@kernel.dk>
 <20100302083906.GQ5768@kernel.dk>
 <20100302093548.GB21014@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302093548.GB21014@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 01:35:48AM -0800, Dmitry Torokhov wrote:
> On Tue, Mar 02, 2010 at 09:39:07AM +0100, Jens Axboe wrote:
> > On Tue, Mar 02 2010, Jens Axboe wrote:
> > > On Tue, Mar 02 2010, Jens Axboe wrote:
> > > > On Mon, Mar 01 2010, Dmitry Torokhov wrote:
> > > > > Hi,
> > > > > 
> > > > > It looks like block tree that has been pulled today into mainline is
> > > > > busted, I am getting the Opps below on boot with the following commit:
> > > > > 
> > > > > commit b1bf9368407ae7e89d8a005bb40beb70a41df539
> > > > > Merge: 524df55 4671a13
> > > > > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > Date:   Mon Mar 1 09:00:29 2010 -0800
> > > > > 
> > > > >     Merge branch 'for-2.6.34' of git://git.kernel.dk/linux-2.6-block
> > > > >  
> > > > > 
> > > > > but not with the previous one:
> > > > > 
> > > > > commit 524df55725217b13d5a232fb5badb5846418ea0e
> > > > > Merge: 0f45339 6679ee1
> > > > > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > Date:   Mon Mar 1 08:58:44 2010 -0800
> > > > > 
> > > > >     Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
> > > > > 
> > > > > This is on plain Fedora 12 VM.
> > > > > 
> > > > > Thanks.
> > > > > 
> > > > > -- 
> > > > > Dmitry
> > > > > 
> > > > > sd 2:0:0:0: Attached scsi generic sg1 type 0
> > > > > sd 2:0:0:0: [sda] 16777216 512-byte logical blocks: (8.58 GB/8.00 GiB)
> > > > > sd 2:0:0:0: [sda] Write Protect is off
> > > > > sd 2:0:0:0: [sda] Cache data unavailable
> > > > > sd 2:0:0:0: [sda] Assuming drive cache: write through
> > > > > sd 2:0:0:0: [sda] Cache data unavailable
> > > > > sd 2:0:0:0: [sda] Assuming drive cache: write through
> > > > >  sda: sda1 sda2
> > > > > sd 2:0:0:0: [sda] Cache data unavailable
> > > > > sd 2:0:0:0: [sda] Assuming drive cache: write through
> > > > > sd 2:0:0:0: [sda] Attached SCSI disk
> > > > > device-mapper: multipath: version 1.1.1 loaded
> > > > > dracut: Scanning devices sda2  for LVM volume groups 
> > > > > dracut: Reading all physical volumes. This may take a while...
> > > > > dracut: Found volume group "VolGroup" using metadata type lvm2
> > > > > dracut: 2 logical volume(s) in volume group "VolGroup" now active
> > > > > EXT4-fs (dm-0): mounted filesystem with ordered data mode
> > > > > BUG: unable to handle kernel NULL pointer dereference at (null)
> > > > > IP: [<ffffffff81128ee1>] mpage_end_io_read+0x45/0x6f
> > > > > PGD 3b776067 PUD 3b7b1067 PMD 0 
> > > > > Oops: 0002 [#1] SMP 
> > > > > last sysfs file: /sys/kernel/uevent_seqnum
> > > > > CPU 0 
> > > > > Modules linked in: dm_multipath mptspi mptscsih mptbase scsi_transport_spi floppy [last unloaded: scsi_wait_scan]
> > > > > 
> > > > > Pid: 1, comm: init Not tainted 2.6.33 #4 440BX Desktop Reference Platform/VMware Virtual Platform
> > > > > RIP: 0010:[<ffffffff81128ee1>]  [<ffffffff81128ee1>] mpage_end_io_read+0x45/0x6f
> > > > 
> > > > Can you check where that is? Just do a gdb vmlinux and then an
> > > > l *mpage_end_io_read+0x45
> > > 
> > > I tried checking mine here, but we must be using vastly different gcc
> > > versions. So I'd like that output. Can you also try and see if reverting
> > > 9f7cdbc33f36d28e57eaba0093f68f0d14c38c5b makes it work?
> > 
> > OK, so disasm of that reveals that
> > 
> >   12:   3e 80 0f 08               orb    $0x8,%ds:(%rdi)
> > 
> > is the start of the faulting instruction. You are running UP. 0x8 is the
> > 4th bit, so I'd be surprised if that isn't SetPageUptodate(page).
> > 
> 
> Sorry, don't have access to that box at the moment... Will try checking
> tomorrow.
> 

You are absolutely right, it crashes in SetPageUptodate():

(gdb) l *bio_endio+0x2b
0xffffffff8112209d is in bio_endio (fs/bio.c:1433).
1428		else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
1429			error = -EIO;
1430	
1431		if (bio->bi_end_io)
1432			bio->bi_end_io(bio, error);
1433	}
1434	EXPORT_SYMBOL(bio_endio);
1435	
1436	void bio_pair_release(struct bio_pair *bp)
1437	{
(gdb) l *mpage_end_io_read+0x45
0xffffffff811268b1 is in mpage_end_io_read (/home/dtor/kernel/linus/arch/x86/include/asm/bitops.h:63).
58	 */
59	static __always_inline void
60	set_bit(unsigned int nr, volatile unsigned long *addr)
61	{
62		if (IS_IMMEDIATE(nr)) {
63			asm volatile(LOCK_PREFIX "orb %1,%0"
64				: CONST_MASK_ADDR(nr, addr)
65				: "iq" ((u8)CONST_MASK(nr))
66				: "memory");
67		} else {
(gdb) l *mpage_end_io_read+0x44
0xffffffff811268b0 is in mpage_end_io_read (fs/mpage.c:53).
48			struct page *page = bvec->bv_page;
49	
50			if (--bvec >= bio->bi_io_vec)
51				prefetchw(&bvec->bv_page->flags);
52	
53			if (uptodate) {
54				SetPageUptodate(page);
55			} else {
56				ClearPageUptodate(page);
57				SetPageError(page);

-- 
Dmitry
