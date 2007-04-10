Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbXDJL3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbXDJL3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbXDJL3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:29:47 -0400
Received: from ms-smtp-03.ohiordc.rr.com ([65.24.5.137]:50002 "EHLO
	ms-smtp-03.ohiordc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbXDJL3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:29:44 -0400
Date: Tue, 10 Apr 2007 07:28:52 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, sailer@watson.ibm.com,
       zohar@linux.vnet.ibm.com, serue@us.ibm.com
Subject: Re: 2.6.21-rc6-mm1 ima "BUG: held lock freed!"
Message-ID: <20070410112852.GA8147@nineveh.rivenstone.net>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, sailer@watson.ibm.com,
	zohar@linux.vnet.ibm.com, serue@us.ibm.com
References: <20070408143559.f5014629.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jhf@columbus.rr.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 08, 2007 at 02:35:59PM -0700, Andrew Morton wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/
>
    I'm seeing this while booting:

ima (ima_init): No TPM chip found(rc = -19), activating TPM-bypass!

=========================
[ BUG: held lock freed! ]
-------------------------
swapper/1 is freeing memory c04c7660-c04c76a3, with a lock still held there!
 (ima_queue_lock){--..}, at: [<c0202710>] ima_create_htable+0x10/0x90
1 lock held by swapper/1:
 #0:  (ima_queue_lock){--..}, at: [<c0202710>] ima_create_htable+0x10/0x90

stack backtrace:
 [<c0105959>] dump_trace+0x1d9/0x210
 [<c01059aa>] show_trace_log_lvl+0x1a/0x30
 [<c0106612>] show_trace+0x12/0x20
 [<c01066d6>] dump_stack+0x16/0x20
 [<c014fd3a>] debug_check_no_locks_freed+0x17a/0x180
 [<c014cdbf>] debug_mutex_init+0x1f/0x50
 [<c0145451>] __mutex_init+0x41/0x50
 [<c020277d>] ima_create_htable+0x7d/0x90
 [<c020286f>] ima_init+0x3f/0x270
 [<c051b765>] init_evm+0x1f5/0x250
 [<c05015d2>] kernel_init+0x132/0x320
 [<c010532f>] kernel_thread_helper+0x7/0x18
 =======================

    I saw this in -rc5-mm4 also.

    I couldn't find a contact address in MAINTAINERS, so I've CC'd the
two authors listed on top of ima_create_htable.c , as well as the
first submitter of the IMA stuff I found in my LKML archive.

    As an aside, this computer does have (some sort of) TPM chip, but
the driver is built as a module, and not loaded at this point (not a
worry for me, I don't intend to use it).

--
Joseph Fannin
jfannin@gmail.com || jhf@columbus.rr.com

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGG3T01/BPLCVlRuARAkZ1AKCg5chHFKuYupeMfP9rzy5UR6c3IwCgr4JP
rZKK+DiEaxp0bnMEM9n6QCs=
=qdy4
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
