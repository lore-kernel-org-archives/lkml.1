Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbYGMMF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbYGMMF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 08:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYGMMFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 08:05:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41705 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYGMMFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 08:05:17 -0400
Date: Sun, 13 Jul 2008 14:06:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: jim owens <jowens@hp.com>
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080713120602.GC7517@elf.ucw.cz>
References: <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed> <4874C3E8.20804@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4874C3E8.20804@hp.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> NEED - provide way for SAN and hardware raid storage to do
> its snapshot/copy function while the system was in-use and
> get an image that could mount cleanly.  Without freeze, at
> a minimum we usually needed filesystem metadata recovery
> to run, worst case is completely unusable snapshits :)
>
> freezefs() is single-level:
>
>    ENOTSUPPOTED - by any other fs
>    EOK - done
>    EINPROGRESS
>    EALREADY
>
> As implemented, freezefs only ensures the metadata is
> consistent so the filesystem copy can mount anywhere.
>
> This means ONLY SOME metadata (or no metadata) is flushed and
> then all metadata updates are stopped.  User/kernel writes
> to already allocated file pages WILL go to a frozen disk.

That's the difference here. They do write file data, and thus avoid
mmap()-writes problem.

...and they _still_ provide auto-thaw.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
