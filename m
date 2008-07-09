Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYGIMZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYGIMZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYGIMZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:25:00 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60424 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752085AbYGIMY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:24:59 -0400
Date: Wed, 9 Jul 2008 08:24:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: Arjan van de Ven <arjan@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>,
       hch@infradead.org, pavel@suse.cz, t-sato@yk.jp.nec.com,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709122401.GK9957@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
	pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
	viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, axboe@kernel.dk,
	mtk.manpages@googlemail.com
References: <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709114958.GV11558@disturbed>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 09:49:58PM +1000, Dave Chinner wrote:
> (e) none of the above.  The kernel compilation will appear to pause
> until the filesystem is unfrozen. No other visible effect should
> occur. It will get blocked in a write or filesystem transaction
> because the fs is frozen.

So if the process which froze the filesystem accidentally tries
writing to a log file (or database file containing the backup
information, or whatever) that happens to be on the filesystem that is
frozen, that process will get blocked and you end up in a deadlock;
did I get that right?

						- Ted
