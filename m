Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZAKCs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZAKCs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 21:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZAKCsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 21:48:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36024 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbZAKCsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 21:48:21 -0500
Date: Sun, 11 Jan 2009 03:47:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alain Knaff <alain@knaff.lu>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [GIT PULL] bzip2/lzma kernel compression
Message-ID: <20090111024756.GB7077@elte.hu>
References: <200901091845.n09IjBsT003630@terminus.zytor.com> <86802c440901091252r2eab513dnf048851aea505d8d@mail.gmail.com> <86802c440901091343p6797536bxf73107fa1672d29b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440901091343p6797536bxf73107fa1672d29b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Fri, Jan 9, 2009 at 12:52 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Fri, Jan 9, 2009 at 10:45 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >> Hi Linus,
> >>
> >> This tree contains the bzip2 and LZMA kernel compression work that
> >> Alain Knaff has done.  Sending this as a separate pull request in case
> >> you think that it is too late or immature for this cycle.
> >>
> >> The good part is that it is a highly "brittle" feature -- if it fails,
> >> it will fail noisily and obviously.
> >>
> >> I have not included the ARM parts that Alain developed; I will leave
> >> those to be fed through rmk.
> >>
> >> One of the main attractions of this patchset is that it uses the newer
> >> lib/zlib_inflate code even for the kernel decompressor.  Once all
> >> architectures that use the older lib/inflate.c have been converted
> >> over, we can remove that code entirely.
> >
> > it seems still have some problem
> > mydisk13_x86_64.lzma is by lzma -9
> >
> > [   47.404316] RAMDISK: lzma image found at block 0
> > [   51.676838] RAMDISK: incomplete write (-28 != 130)
> > [   51.894794] calling  5_generic_delete_inode_async+0x0/0xa9 @ 2316
> > [   51.900895] initcall 5_generic_delete_inode_async+0x0/0xa9 returned
> > 0 after 3 usecs
> > [   51.901117] kjournald starting.  Commit interval 5 seconds
> > [   51.901130] EXT3 FS on ram0, internal journal
> > [   51.901138] EXT3-fs: mounted filesystem with ordered data mode.
> > [   51.901151] VFS: Mounted root (ext3 filesystem) on device 1:0.
> > [   51.901168] async_waiting @ 1
> > [   51.904191] calling  6_generic_delete_inode_async+0x0/0xa9 @ 2317
> > [   51.907123] initcall 6_generic_delete_inode_async+0x0/0xa9 returned
> > 0 after 2861 usecs
> > [   51.947093] async_continuing @ 1 after 44846 usec
> > [   51.951839] Freeing unused kernel memory: 448k freed
> > [   51.957245] init_special_inode: bogus i_mode (4467)
> >
> 
> the .lzma is corrupted. it is strange. i was compiling kernel when lzma 
> it...
> 
> recreate that .lzma the kernel works well.

was the linux/.lzma file corrupted, and once you removed the stale file it 
all works fine and the problem does not come back?

I.e. the tree as offered by hpa is fine?

	Ingo
