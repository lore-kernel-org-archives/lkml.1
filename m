Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYGIGm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYGIGm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 02:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYGIGmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 02:42:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:40127 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYGIGmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 02:42:16 -0400
Date: Tue, 8 Jul 2008 23:41:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, miklos@szeredi.hu, tytso@mit.edu, pavel@suse.cz,
       t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080708234120.5072111f@infradead.org>
In-Reply-To: <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu>
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

On Wed, 09 Jul 2008 08:22:56 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Wed, 9 Jul 2008, Christoph Hellwig wrote:
> > On Wed, Jul 09, 2008 at 08:13:21AM +0200, Miklos Szeredi wrote:
> > > This would mean that freeze and thaw will have to be done on the
> > > same file descriptor, but this isn't unreasonable to expect, is
> > > it?
> > 
> > It is certainly not the current use case, where you run one command
> > to freeze the filesystem and another one to unfreeze it.
> 
> So instead of
> 
>   freeze_fs mountpoint
>   backup-command
>   unfreeze_fs mountpoint
> 
> the user would have do to
> 
>   run_freezed mountpoint backup-command
> 
> I find the second one nicer, regardless of any reliability issues.

nah he needs to do

make_snapshot ; backup-command ; unref_snapshot.

freezing isn't the right solution for the backup problem ;)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
