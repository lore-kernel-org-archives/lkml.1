Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYGIG4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYGIG4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 02:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYGIG4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 02:56:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:33549 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYGIG4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 02:56:32 -0400
Date: Tue, 8 Jul 2008 23:55:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: miklos@szeredi.hu, hch@infradead.org, tytso@mit.edu, pavel@suse.cz,
       t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080708235502.1c52a586@infradead.org>
In-Reply-To: <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu>
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
	<E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 08:48:42 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Tue, 8 Jul 2008, Arjan van de Ven wrote:
> > nah he needs to do
> > 
> > make_snapshot ; backup-command ; unref_snapshot.
> > 
> > freezing isn't the right solution for the backup problem ;)
> 
> Confused, what's freezing _is_ for then?  Patch description says:
> 
>   Currently, ext3 in mainline Linux doesn't have the freeze feature
> which suspends write requests.  So, we cannot take a backup which
> keeps the filesystem's consistency with the storage device's features
>   (snapshot and replication) while it is mounted.

I tihnk the idea there is

freeze . do the snapshot op . unfreeze . make backup of snapshot

one can argue about the need of doing the first 3 steps via a userland
loop; it sure sounds like one needs to be really careful to not do any
writes to the fs from the app that does snapshots (and that includes
doing any syscalls in the kernel that allocate memory.. just because
that already could cause unrelated data to be written from inside the
app. Not fun.)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
