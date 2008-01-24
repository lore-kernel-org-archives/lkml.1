Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbYAXV7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbYAXV7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYAXV67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:58:59 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52639 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbYAXV66 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:58:58 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
In-Reply-To: Your message of "Thu, 24 Jan 2008 23:36:00 +0300."
             <200801242336.00340.a1426z@gawab.com>
From: Valdis.Kletnieks@vt.edu
References: <200801242336.00340.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201211935_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Jan 2008 16:58:55 -0500
Message-ID: <15182.1201211935@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201211935_2846P
Content-Type: text/plain; charset=us-ascii

On Thu, 24 Jan 2008 23:36:00 +0300, Al Boldi said:
> data=ordered mode has proven reliable over the years, and it does this by 
> ordering filedata flushes before metadata flushes.  But this sometimes 
> causes contention in the order of a 10x slowdown for certain apps, either 
> due to the misuse of fsync or due to inherent behaviour like db's, as well 
> as inherent starvation issues exposed by the data=ordered mode.

If they're misusing it, they should be fixed.  There should be a limit to
how much the kernel will do to reduce the pain of doing stupid things.

> This RFC proposes to introduce a tunable which allows to disable fsync and 
> changes ordered into writeback writeout on a per-process basis like this:

Well-written programs only call fsync() when they really do need the semantics
of fsync.  Disabling that is just *asking* for trouble.

>From rfc2821:

6.1 Reliable Delivery and Replies by Email

   When the receiver-SMTP accepts a piece of mail (by sending a "250 OK"
   message in response to DATA), it is accepting responsibility for
   delivering or relaying the message.  It must take this responsibility
   seriously.  It MUST NOT lose the message for frivolous reasons, such
   as because the host later crashes or because of a predictable
   resource shortage.

Some people really *do* think "the CPU took a machine check and after replacing
the motherboard, the resulting fsck ate the file" is a "frivolous" reason to
lose data.

But if you want to give them enough rope to shoot themselves in the foot with,
I'd suggest abusing LD_PRELOAD to replace the fsync() glibc code instead.  No
need to clutter the kernel with rope that can be (and has been) done in userspace.

--==_Exmh_1201211935_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmQofcC3lWbTT17ARAg91AJ9f8ErhsPm8ugAhC6S+gpNBr8OtWgCdF1VL
7Wd8Yt1M2gL+8AUQTqQj9Rw=
=2ISz
-----END PGP SIGNATURE-----

--==_Exmh_1201211935_2846P--
