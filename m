Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbXIUTeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbXIUTeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761480AbXIUTeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:34:04 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60961 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761018AbXIUTeD (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:34:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, Dave Airlie <airlied@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
In-Reply-To: Your message of "Fri, 21 Sep 2007 19:30:04 +0200."
             <46F3FF9C.7040200@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070920220604.GA17536@waste.org> <10207.1190394975@turing-police.cc.vt.edu>
            <46F3FF9C.7040200@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190403228_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Sep 2007 15:33:48 -0400
Message-ID: <4109.1190403228@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190403228_2846P
Content-Type: text/plain; charset=us-ascii

On Fri, 21 Sep 2007 19:30:04 +0200, Jiri Slaby said:
> On 09/21/2007 07:16 PM, Valdis.Kletnieks@vt.edu wrote:

> > Hmm.. maybe I'm chasing a different bug manifested by the same patch.  For me,
> > it's been a solid lockup at X startup since -rc3-mm1, and this patch doesn't
> > change matters.
> 
> This patch probably changes behaviour how the pages are queued on the list
> somehow. Maybe it's insane to suggest everybody with similar problem to try
> LIST_DEBUG, but just give it a try after having one of the patches applied ;).
> (Or have you tried yet?)

OK, had a chance to test it, with Dave Airlie's AGP patch, and here's what it hit:

[  198.925000] list_del corruption. next->prev should be ffff81000118f178, but was ffffffff8067e050
[  198.925000] ------------[ cut here ]------------
[  198.925000] kernel BUG at lib/list_debug.c:72!
[  198.925000] invalid opcode: 0000 [1] PREEMPT SMP 
[  198.925000] last sysfs file: /devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-adapter/i2c-1/i2c-1/dev
[  198.925000] CPU 1 
[  198.925000] Modules linked in:

(Yes, I wish I got a backtrace, but that's as long as it lived.  Apparently,
the netconsole stuff actually writing this stuff out was over on CPU0 which then
proceeded to croak).

Some odd SMP-related race? (x86_64 kernel on a Core2 Duo T7200, if it matters)

--==_Exmh_1190403228_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG9ByccC3lWbTT17ARAr4TAKDWL1bY5VbJpuMCLAEmO9m6Txvm8wCgktZJ
NLNmhiX75p50s21vEYX0gM4=
=0L+r
-----END PGP SIGNATURE-----

--==_Exmh_1190403228_2846P--
