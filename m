Return-Path: <linux-kernel-owner+w=401wt.eu-S966126AbXDGRKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966126AbXDGRKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966131AbXDGRKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:10:41 -0400
Received: from h80ad275a.async.vt.edu ([128.173.39.90]:36611 "EHLO
	h80ad275a.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966126AbXDGRKk (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:10:40 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: johnrobertbanks@fastmail.fm, Jan Harkes <jaharkes@cs.cmu.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
In-Reply-To: Your message of "Sat, 07 Apr 2007 16:11:46 +0200."
             <m34pns46l9.fsf@maximus.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <46157B5B.5000602@gmail.com> <1175817921.18400.1183285196@webmail.messagingengine.com> <461592FB.5060507@zytor.com> <1175819681.20754.1183287946@webmail.messagingengine.com> <461596DE.2020802@zytor.com> <1175823288.25662.1183293506@webmail.messagingengine.com> <4615C780.5040407@zytor.com> <1175833931.8916.1183307802@webmail.messagingengine.com> <20070406152119.GC4228@delft.aura.cs.cmu.edu> <1175914056.9653.1183426876@webmail.messagingengine.com> <20070407033049.GI4228@delft.aura.cs.cmu.edu> <1175925525.21154.1183436614@webmail.messagingengine.com>
            <m34pns46l9.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175965831_4736P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 07 Apr 2007 13:10:31 -0400
Message-ID: <13684.1175965831@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175965831_4736P
Content-Type: text/plain; charset=us-ascii

On Sat, 07 Apr 2007 16:11:46 +0200, Krzysztof Halasa said:

> > Think about it,... read speeds that are some FOUR times the physical
> > disk read rate,... impossible without the use of compression (or
> > something similar).
> 
> It's really impossible with compression only unless you're writing
> only zeros or stuff alike. I don't know what bonnie uses for testing
> but real life data doesn't compress 4 times. Two times, sometimes,

All depends on your data.  From a recent "compress the old logs" job on
our syslog server:

/logs/lennier.cc.vt.edu/2007/03/maillog-2007-0308:       85.4% -- replaced with /logs/lennier.cc.vt.edu/2007/03/maillog-2007-0308.gz

And it wasn't a tiny file either - it's a busy mailserver, the logs run to
several hundred megabytes a day.  Syslogs *often* compress 90% or more,
meaning a 10X compression.

> but then it will be typically slower than disk access (I mean read,
> as write will be much slower).

Actually, as far back as 1998 or so, I was able to document 20% *speedups*
on an AIX system that supported compressed file systems - and that was from
when a 133mz PowerPC 604e was a *fast* machine.   Since then, CPUs have gotten
faster at a faster rate than disks have, even increasing the speedup.

The basic theory is that unless you're sitting close to 100%CPU, it is *faster*
to burn some CPU to compress/decompress a 4K chunk of data down to 2K, and then
move 2K to the disk drive, than it is to move 4K.  It's particularly noticable
for larger files - if you can apply the compression to  remove the need to move
2M of data faster than you can move 2M of data, you win.


--==_Exmh_1175965831_4736P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGF9CHcC3lWbTT17ARAkCjAKD9qQoON7KzBXuBY5sY/4zgVVfjHgCg8joB
EhcogAGY+4wH4uLNqI0kTUE=
=fj85
-----END PGP SIGNATURE-----

--==_Exmh_1175965831_4736P--
