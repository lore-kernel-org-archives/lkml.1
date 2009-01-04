Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbZADTh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbZADTh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbZADThM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:37:12 -0500
Received: from thunk.org ([69.25.196.29]:54427 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676AbZADThK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:37:10 -0500
Date: Sun, 4 Jan 2009 14:36:37 -0500
From: Theodore Tso <tytso@mit.edu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104193637.GB22958@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
	Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
	Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <495FEE66.9080903@ribosome.natur.cuni.cz> <e9e943910901031538m24ff9616na2aaf3a57f161655@mail.gmail.com> <495FF9CE.2020908@ribosome.natur.cuni.cz> <e9e943910901031600o1705dfb3j197f90b62d1f75a6@mail.gmail.com> <495FFECB.5040001@ribosome.natur.cuni.cz> <e9e943910901031641x4c900b6ar5d0f50b648584b7b@mail.gmail.com> <15786.1231041158@turing-police.cc.vt.edu> <e9e943910901040624y69c01b43p1655c0078b969ea6@mail.gmail.com> <20090104184040.GC17558@mit.edu> <Pine.LNX.4.64.0901042015230.31141@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901042015230.31141@anakin>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 08:21:06PM +0100, Geert Uytterhoeven wrote:
> As mentioned before, suspending a laptop (running from hdd), running
> a live CD, and expecting everything to work fine when resuming from
> hdd?
> 
> I think most people get shocked when they discover that mounting
> something read-only may actualy write to the media. This is a bit
> unexpected (hey, if I mount `read-only', I expect that no writes
> will happen), as it behaved differently before the introduction of
> journalling.

It's been this way for about a decade....  that being said, if you
really want to do this, you can today via "mount -o ro,noload /dev/XXX
/mntpt".  However, the system could crash or fail because the
filesystem without having run the journal could be quite inconsistent.  

> As for mounting the root file system read-only during early boot up, and
> remounting it read-write later, I guess it's quite complicated to replay the
> journal (in RAM) on read-only mount, and deferring the replay writeback until
> remounting read-write?

It's not *that* hard; if someone would like to cons up a patch, please
feel free....  but it's certainly not a high priority for me or most
of the other ext3 filesystem developers.

					- Ted
