Return-Path: <linux-kernel-owner+w=401wt.eu-S933304AbXJQUJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbXJQUJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbXJQUJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:09:23 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34410 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761011AbXJQUJW (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:09:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Yi Yang <yang.y.yi@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mj@atrey.karlin.mff.cuni.cz,
       crutcher+kernel@datastacks.com, pavel@ucw.cz, schwab@suse.de
Subject: Re: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef key, try 2
In-Reply-To: Your message of "Wed, 17 Oct 2007 23:22:58 +0800."
             <471628D2.8010903@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <471628D2.8010903@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1192651748_3070P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Oct 2007 16:09:08 -0400
Message-ID: <18386.1192651748@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1192651748_3070P
Content-Type: text/plain; charset=us-ascii

On Wed, 17 Oct 2007 23:22:58 +0800, Yi Yang said:

> SysRq has already provided a similiar help before this patch, but it
> is not so clear that the user doesn't know what happened and what
> he/she should do.

The person is in one of two states:

1) He has been told "recreate the problem, hit alt-sysreq-cokebottle,
and send me the results".  He has a mission, and the only feedback he
needs is (a) that he hit cokebottle and not pepsibottle, and (b) the
resulting output.

2) He's already read the file in Documentation/ and just needs a reminder.
In this case, the fact it's only 2 or 3 lines and doesn't scroll other stuff
out of sight is more important.

> In addition, that funtion has a big loop with another big loop
> embedded which is very inefficient, it is intended to skip some hot

You're optimizing code that hopefully never gets executed, and even if
it does, you have the optimization *backwards*.  If you're worried about
the efficiency, trim it down to output 3 lines - do you realize how many
instructions it takes in the VGA and fb drivers to actually *output* all
these lines? (Seriously - I had a 1.6Ghz P4 laptop, where scrolling the
screen with vga=791 actually ran so slowly that it horqued up the timer
initialization code. *That* was a fun bug to figure out..)

> key help info for such a function as "Changing Loglevel", just print
> a help info for this, that is very unnecessary. In fact, the key '0'
>  - '8' have different results the user should know.

And ironically enough, you then output the same exact text for all levels.


> +static char __read_mostly sysrq_hot_key_table[36] = {
> +	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
> +	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
> +	'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
> +	'u', 'v', 'w', 'x', 'y', 'z'

The lists of 'Not defined' tends to scroll the screen away. The old code
instead focuses on listing the things you *can* do.  If I'm looking at the
help output, I don't care that 'g' is not defined.  I need to be reminded
that 'p' is 'showPc' and D is show-all-locks.

--==_Exmh_1192651748_3070P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHFmvkcC3lWbTT17ARAkAnAJ9kCWTL4thlNuO5ljB6JtLFObOl1gCgrguP
3kEUmM4JzthyB8/paPbay4A=
=FcLu
-----END PGP SIGNATURE-----

--==_Exmh_1192651748_3070P--
