Return-Path: <linux-kernel-owner+w=401wt.eu-S1760956AbXGQGYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbXGQGYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 02:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXGQGYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 02:24:33 -0400
Received: from brick.kernel.dk ([80.160.20.94]:24682 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbXGQGYc (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 02:24:32 -0400
Date: Tue, 17 Jul 2007 08:23:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ian Kumlien <pomac@vapor.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, Linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [BUG] AS io-scheduler.
Message-ID: <20070717062355.GW5195@kernel.dk>
References: <1184512821.10630.26.camel@localhost> <469B9D6B.60101@redhat.com> <20070716172938.GB5195@kernel.dk> <1184615343.10630.40.camel@localhost> <20070716195629.GO5195@kernel.dk> <1184616889.10630.55.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1184616889.10630.55.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16 2007, Ian Kumlien wrote:
> On mån, 2007-07-16 at 21:56 +0200, Jens Axboe wrote:
> > On Mon, Jul 16 2007, Ian Kumlien wrote:
> > > On mån, 2007-07-16 at 19:29 +0200, Jens Axboe wrote:
> > > > On Mon, Jul 16 2007, Chuck Ebbert wrote:
> > > > > On 07/15/2007 11:20 AM, Ian Kumlien wrote:
> > > > > > I had emerge --sync failing several times... 
> > > > > > 
> > > > > > So i checked dmesg and found some info, attached further down.
> > > > > > This is a old VIA C3 machine with one disk, it's been running most
> > > > > > kernels in the 2.6.x series with no problems until now.
> > > > > > 
> > > > > > PS. Don't forget to CC me
> > > > > > DS.
> > > > > > 
> > > > > > BUG: unable to handle kernel paging request at virtual address ea86ac54
> > > > > >  printing eip:
> > > > > > c022dfec
> > > > > > *pde = 00000000
> > > > > > Oops: 0000 [#1]
> > > > > > Modules linked in: eeprom i2c_viapro vt8231 i2c_isa skge
> > > > > > CPU:    0
> > > > > > EIP:    0060:[<c022dfec>]    Not tainted VLI
> > > > > > EFLAGS: 00010082   (2.6.22.1 #26)
> > > > > > EIP is at as_can_break_anticipation+0xc/0x190
> > > > > > eax: dfcdaba0   ebx: dfcdaba0   ecx: 0035ff95   edx: cb296844
> > > > > > esi: cb296844   edi: dfcdaba0   ebp: 00000000   esp: ceff6a70
> > > > > > ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> > > > > > Process rsync (pid: 1667, ti=ceff6000 task=d59cf5b0 task.ti=ceff6000)
> > > > > > Stack: cb296844 00000001 cb296844 dfcdaba0 00000000 c022efc8 cb296844
> > > > > > 00000000 
> > > > > >        dfcffb9c c0227a76 dfcffb9c 00000000 c016e96e cb296844 00000000
> > > > > > dfcffb9c 
> > > > > >        00000000 c022af64 00000000 dfcffb9c 00000008 00000000 08ff6b30
> > > > > > c04d1ec0 
> > > > > > Call Trace:
> > > > > >  [<c022efc8>] as_add_request+0xa8/0xc0
> > > > > >  [<c0227a76>] elv_insert+0xa6/0x150
> > > > > >  [<c016e96e>] bio_phys_segments+0xe/0x20
> > > > > >  [<c022af64>] __make_request+0x384/0x490
> > > > > >  [<c02add1e>] ide_do_request+0x6ee/0x890
> > > > > >  [<c02294ab>] generic_make_request+0x18b/0x1c0
> > > > > >  [<c022b596>] submit_bio+0xa6/0xb0
> > > > > >  [<c013b7b8>] mempool_alloc+0x28/0xa0
> > > > > >  [<c016bb66>] __find_get_block+0xf6/0x130
> > > > > >  [<c016e0bc>] bio_alloc_bioset+0x8c/0xf0
> > > > > >  [<c016b647>] submit_bh+0xb7/0xe0
> > > > > >  [<c016c1f8>] ll_rw_block+0x78/0x90
> > > > > >  [<c019c85d>] search_by_key+0xdd/0xd20
> > > > > >  [<c016c201>] ll_rw_block+0x81/0x90
> > > > > >  [<c011f190>] irq_exit+0x40/0x60
> > > > > >  [<c01066e4>] do_IRQ+0x94/0xb0
> > > > > >  [<c0104bc3>] common_interrupt+0x23/0x30
> > > > > >  [<c018beca>] reiserfs_read_locked_inode+0x6a/0x490
> > > > > >  [<c018e580>] reiserfs_find_actor+0x0/0x20
> > > > > >  [<c018c33b>] reiserfs_iget+0x4b/0x80
> > > > > >  [<c018e570>] reiserfs_init_locked_inode+0x0/0x10
> > > > > >  [<c0189824>] reiserfs_lookup+0xa4/0xf0
> > > > > >  [<c0157b03>] do_lookup+0xa3/0x140
> > > > > >  [<c0159265>] __link_path_walk+0x615/0xa20
> > > > > >  [<c0168a18>] __mark_inode_dirty+0x28/0x150
> > > > > >  [<c01631c1>] mntput_no_expire+0x11/0x50
> > > > > >  [<c01596b2>] link_path_walk+0x42/0xb0
> > > > > >  [<c0159960>] do_path_lookup+0x130/0x150
> > > > > >  [<c015a190>] __user_walk_fd+0x30/0x50
> > > > > >  [<c0154766>] vfs_lstat_fd+0x16/0x40
> > > > > >  [<c01547df>] sys_lstat64+0xf/0x30
> > > > > >  [<c0103c42>] syscall_call+0x7/0xb
> > > > > >  =======================
> > > > > 
> > > > > static int as_can_break_anticipation(struct as_data *ad, struct request *rq)
> > > > > {
> > > > >         struct io_context *ioc;
> > > > >         struct as_io_context *aic;
> > > > > 
> > > > >         ioc = ad->io_context;  <======== ad is bogus
> > > > >         BUG_ON(!ioc);
> > > > > 
> > > > > 
> > > > > Call chain is:
> > > > > 
> > > > > 	as_add_request
> > > > > 	as_update_rq:
> > > > > 	        if (ad->antic_status == ANTIC_WAIT_REQ
> > > > >         	                || ad->antic_status == ANTIC_WAIT_NEXT) {
> > > > >                 	if (as_can_break_anticipation(ad, rq))
> > > > >                         	as_antic_stop(ad);
> > > > >         	}
> > > > > 
> > > > > 
> > > > > So somehow 'ad' became invalid between the time ad->antic_status was
> > > > > checked and as_can_break_anticipation() tried to access ad->io_context?
> > > > 
> > > > That's impossible, ad is persistent unless the io scheduler is attempted
> > > > removed. Did you fiddle with switching io schedulers while this
> > > > happened? If not, then something corrupted your memory. And I'm not
> > > > aware of any io scheduler switching bugs, so the oops would still be
> > > > highly suspect if so.
> > > 
> > > I wasn't fiddling with the scheduler, it's quite happily been running AS
> > > for quite some time.
> > 
> > OK, that rules that out then. Then your oops looks very much like
> > hardware trouble. Perhaps a border liner PSU? Just an idea.
> 
> It uses a laptop psu, that doesn't need cooling, this is a microitx
> board =)

Yeah I know, I've had the same setup for a "server" at some point in the
past. It wasn't very stable for me under load, but that doesn't mean
it's a general problem of course :-)

> > You could try and boot with the noop IO scheduler and see if it still
> > oopses. Not sure would else to suggest, your box will likely pass
> > memtest just fine.
> 
> It's currently running with cfq since ~2 days without a problem.
> 
> I really can't take it down and do a memtest on it, it's my mailserver,
> webserver, firewall etc etc =)

And you shouldn't, as I wrote I don't think that memtest would uncover
anything.

> Just let me know what kind of information you might want and i'll put it
> all up... =)

Lets see if it remains stable with CFQ, I have no further ideas right
now. The oops is impossible.

-- 
Jens Axboe

