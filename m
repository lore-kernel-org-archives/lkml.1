Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbYGIHIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbYGIHIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 03:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYGIHId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 03:08:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42314 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYGIHIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 03:08:32 -0400
To: arjan@infradead.org
CC: miklos@szeredi.hu, miklos@szeredi.hu, hch@infradead.org, tytso@mit.edu,
       pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       mtk.manpages@googlemail.com
In-reply-to: <20080708235502.1c52a586@infradead.org> (message from Arjan van
	de Ven on Tue, 8 Jul 2008 23:55:02 -0700)
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080630212450t-sato@mail.jp.nec.com>
	<20080701081026.GB16691@infradead.org>
	<20080707110730.GG5643@ucw.cz>
	<20080708231026.GP11558@disturbed>
	<20080708232031.GE18195@elf.ucw.cz>
	<20080709005254.GQ11558@disturbed>
	<20080709010922.GE9957@mit.edu>
	<E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu>
	<20080709061621.GA5260@infradead.org>
	<E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu>
	<20080708234120.5072111f@infradead.org>
	<E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org>
Message-Id: <E1KGTmZ-0006oz-Qi@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jul 2008 09:08:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008, Arjan van de Ven wrote:
> I tihnk the idea there is
> 
> freeze . do the snapshot op . unfreeze . make backup of snapshot

Ah, so then my proposal would become

  run_frozen mountpoint do-snapshot
  do-backup
  release-snapshot

and if they are afraid of deadlocks they can just implement the
timeout in userspace:

  run_frozen -t timeout mountpoint do-snapshot

'run_frozen' can be a trivial 30 line app, that can be guaranteed not
to deadlock.

> one can argue about the need of doing the first 3 steps via a userland
> loop; it sure sounds like one needs to be really careful to not do any
> writes to the fs from the app that does snapshots (and that includes
> doing any syscalls in the kernel that allocate memory.. just because
> that already could cause unrelated data to be written from inside the
> app. Not fun.)

Userland always has to be careful when messing with raw devices.  That
alone is not a reason to put the snapshotting facility in kernel IMO.

Miklos
