Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbYBMH0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbYBMH0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbYBMH0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:26:33 -0500
Received: from nb-fmf82.fmnsedu.rug.nl ([129.125.61.82]:54689 "EHLO
	kronos.fmf.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbYBMH0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:26:33 -0500
Date: Wed, 13 Feb 2008 08:26:27 +0100
From: Bart Dopheide <dopheide@fmf.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Kernel BUG at fs/mpage.c:489
Message-ID: <20080213072627.GB2174@fmf.nl>
References: <20080212194546.GA2174@fmf.nl> <20080212215006.170ade88@core> <200802131205.45493.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
In-Reply-To: <200802131205.45493.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 13, 2008 at 12:05:45PM +1100, Nick Piggin wrote:
:)On Wednesday 13 February 2008 08:50, Alan Cox wrote:
:)> Almost certainly a hardware fail of some sort.
:)
:)Right, but the kernel shouldn't go bug...

Indeed, that's why I'm reporting.


:)I don't have a copy of your exact source code... which condition in
:)__mpage_writepage went BUG?

BUG_ON(buffer_locked(bh));

In a bit of context:
482:    if (page_has_buffers(page)) {
483:            struct buffer_head *head = page_buffers(page);
484:            struct buffer_head *bh = head;
485:
486:            /* If they're all mapped and dirty, do it */
487:            page_block = 0;
488:            do {
489:                    BUG_ON(buffer_locked(bh));
490:                    if (!buffer_mapped(bh)) {
491:                            /*
492:                             * unmapped dirty buffers are created by
493:                             * __set_page_dirty_buffers -> mmapped data
494:                             */
495:                            if (buffer_dirty(bh))
496:                                    goto confused;
497:                            if (first_unmapped == blocks_per_page)
498:                                    first_unmapped = page_block;
499:                            continue;
500:                    }


//Bart

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHspujO+xo//XQJXURAjeLAKDVbqP8WbjB1Mh5ucnikwhKUWS94QCg99Hw
jxZwKbnBnYSBUQYWOrtGsIo=
=j2ew
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
