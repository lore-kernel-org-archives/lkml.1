Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbYAJUs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbYAJUs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbYAJUsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:48:50 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59714 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYAJUst (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:48:49 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Rik van Riel <riel@redhat.com>
Cc: Jakob Oestergaard <jakob@unthought.net>,
       Anton Salikhmetov <salikhmetov@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in msync()
In-Reply-To: Your message of "Wed, 09 Jan 2008 18:41:41 EST."
             <20080109184141.287189b8@bree.surriel.com>
From: Valdis.Kletnieks@vt.edu
References: <1199728459.26463.11.camel@codedot> <20080109155015.4d2d4c1d@cuia.boston.redhat.com> <26932.1199912777@turing-police.cc.vt.edu> <20080109170633.292644dc@cuia.boston.redhat.com> <20080109223340.GH25527@unthought.net>
            <20080109184141.287189b8@bree.surriel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199998102_2824P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Jan 2008 15:48:22 -0500
Message-ID: <5273.1199998102@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199998102_2824P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 Jan 2008 18:41:41 EST, Rik van Riel said:

> I guess a third possible time (if we want to minimize the number of
> updates) would be when natural syncing of the file data to disk, by
> other things in the VM, would be about to clear the I_DIRTY_PAGES
> flag on the inode.  That way we do not need to remember any special
> "we already flushed all dirty data, but we have not updated the mtime
> and ctime yet" state.
> 
> Does this sound reasonable?

Is it possible that a *very* large file (multi-gigabyte or even bigger database,
for example) would never get out of I_DIRTY_PAGES, because there's always a
few dozen just-recently dirtied pages that haven't made it out to disk yet?

Of course, getting a *consistent* backup of a file like that is quite the
challenge already, because of the high likelyhood of the file being changed
while the backup runs - that's why big sites often do a 'quiesce/snapshot/wakeup'
on a database and then backup the snapshot...


--==_Exmh_1199998102_2824P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHhoSWcC3lWbTT17ARAn1mAJ48AjVv7lCnK64HDWknbOZPhx4kZgCeNAAx
1fx+ay5cVP3Trm0CcZPIZO8=
=DyL9
-----END PGP SIGNATURE-----

--==_Exmh_1199998102_2824P--
