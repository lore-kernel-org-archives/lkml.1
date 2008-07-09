Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYGIBMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYGIBMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 21:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYGIBMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 21:12:13 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33409 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752677AbYGIBMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 21:12:12 -0400
Date: Tue, 8 Jul 2008 21:09:22 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@infradead.org>,
       Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       axboe@kernel.dk, mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709010922.GE9957@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@infradead.org>,
	Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org,
	viro@ZenIV.linux.org.uk,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	axboe@kernel.dk, mtk.manpages@googlemail.com
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709005254.GQ11558@disturbed>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 10:52:54AM +1000, Dave Chinner wrote:
> If you walk enough inodes while the filesystem is frozen, it
> theoretically could happen.  Typically a filesystem is only for a
> few seconds at a time so in the real world this has never, ever been
> a problem.

I had argued for the timeout (and so it's mostly my fault that
Takashi-San included it as a feature) mainly because I was (and still
amm) deeply paranoid about the competence of the application
programers who might use this feature.  I could see them screwing up
leaving it locked forever --- perhaps when their program core dumps or
when the user types ^C and they forgot to install a signal handler,
leaving the filesystem frozen forever.

In the meantime, user applications that try to create files on that
filesystem, or write to files already opened when the filesystem are
frozen will accumulate dirty pages in the page cache, until the system
finally falls over.

Think about some of the evil perpetrated by hal and the userspace
suspend-resume scripts (and how much complexity with random XML
fragments getting parsed by various dbus plugins), and tell me with a
straight face that you would trust these modern-day desktop
application writers with this interface.  Because they *will* find
some interesting way to (ab)use it.....

Also, I didn't think the extra code complexity to implements timeouts
was *that* bad --- it seemed fairly small for the functionality.

Best regards,

						- Ted
