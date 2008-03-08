Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYCHS6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYCHS6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 13:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYCHS6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 13:58:12 -0500
Received: from tuxrocks.com ([208.78.103.217]:43424 "EHLO tuxrocks.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbYCHS6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 13:58:12 -0500
Message-ID: <47D2E197.5090806@tuxrocks.com>
Date: Sat, 08 Mar 2008 12:57:27 -0600
From: Frank Sorenson <frank@tuxrocks.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Ingo Molnar <mingo@elte.hu>, Matt_Domsch@dell.com,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] revert "dcdbas: add DMI-based module autloading"
References: <47D02940.1030707@tuxrocks.com> <20080306184954.GA15492@elte.hu>	 <47D1971A.7070500@tuxrocks.com> <47D23B7E.3020505@tuxrocks.com>	 <20080308082243.GA18123@elte.hu> <1205000172.8748.4.camel@lov.site>
In-Reply-To: <1205000172.8748.4.camel@lov.site>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Kay Sievers wrote:
> Frank, can you grep for 'dcdbas' in the modprobe config files:
>   modprobe -c | grep dcdbas
> ?
> 
> I wonder what's going on here, that modprobe calls itself.
> 
> Thanks,
> Kay

Aha.  This is indeed where the problem was.  A line in the modprobe
config files was supposed to cause dcdbas to load, but was instead
causing modprobe to call itself repeatedly for dcdbas.  I don't know why
an incorrect line was there, but removing it from the config allows
dcdbas to load without problem manually, and the autoload patch loads it
automatically.

Sincere apologies to everyone for causing the fire drill on a false
alarm.  Since fixing my config makes things work again, and nobody else
sees the problem, the autoload patch should stay.

Thanks for the help tracking down the issue.

Frank (off to hide in the corner)
- --
Frank Sorenson - KD7TZK
Linux Systems Engineer, DSS Engineering, UBS AG
frank@tuxrocks.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFH0uGTaI0dwg4A47wRApD/AKDsYtoatp/mJShgdHVDj5RKOH8GsgCg4w8D
WA8R+ZpjHPManfxvIuqD+lY=
=4c2w
-----END PGP SIGNATURE-----
