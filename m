Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbYGNGfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbYGNGfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 02:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYGNGfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 02:35:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52875 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbYGNGfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 02:35:37 -0400
Date: Mon, 14 Jul 2008 08:36:17 +0200
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
Message-ID: <20080714063617.GF31949@elf.ucw.cz>
References: <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed> <4874C3E8.20804@hp.com> <20080713120602.GC7517@elf.ucw.cz> <487A383F.50600@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487A383F.50600@hp.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-07-13 13:15:43, jim owens wrote:
> Pavel Machek wrote:
>
>>> This means ONLY SOME metadata (or no metadata) is flushed and
>>> then all metadata updates are stopped.  User/kernel writes
>>> to already allocated file pages WILL go to a frozen disk.
>>
>> That's the difference here. They do write file data, and thus avoid
>> mmap()-writes problem.
>>
>> ...and they _still_ provide auto-thaw.
>> 								Pavel
>
> One of the hardest things to make people understand is that
> stopping file data writes in the filesystem during a freeze
> is not just dangerous, it is also __worthless__ unless you
> have a complete "user environment freeze" mechanism.

Eh?

> And unless each independent component has a freeze and they
> can all be coordinated, the data in the pipeline is never
> stable enough to say "if you stop all writes to disk and
> take a snapshot, this is the same as an orderly shutdown,
> backup, restore, and startup".

If you also freeze data writes, at least snapshot is not worse than
_unexpected_ shutdown.

And apps should already be ready for unexpected shutdowns (using fsync
etc).

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
