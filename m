Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYLEDfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYLEDfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYLEDfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:35:43 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44767 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYLEDfm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:35:42 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Geoffrey McRae <geoff@rabidhost.com>
Cc: Peter Teoh <htmldeveloper@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org
Subject: Re: New Security Features, Please Comment
In-Reply-To: Your message of "Fri, 05 Dec 2008 09:30:54 +1100."
             <1228429854.7546.6.camel@lappy.spacevs.com>
From: Valdis.Kletnieks@vt.edu
References: <1228260494.24232.21.camel@compy.ivent.com.au> <20081203005338.6472db7a@lxorguk.ukuu.org.uk> <1228268657.6679.4.camel@lappy.spacevs.com> <20081203124252.GD11807@mail.local.tull.net> <1228344292.6993.27.camel@lappy.spacevs.com> <20081203230820.4473a162@lxorguk.ukuu.org.uk> <804dabb00812031527k3fae11dcnef3b1696c3d136f8@mail.gmail.com> <1228347656.6993.31.camel@lappy.spacevs.com> <80413.1228427770@turing-police.cc.vt.edu>
            <1228429854.7546.6.camel@lappy.spacevs.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1228448127_3727P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Dec 2008 22:35:27 -0500
Message-ID: <95180.1228448127@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1228448127_3727P
Content-Type: text/plain; charset=us-ascii

On Fri, 05 Dec 2008 09:30:54 +1100, Geoffrey McRae said:
> On Thu, 2008-12-04 at 16:56 -0500, Valdis.Kletnieks@vt.edu wrote:

> > 	while (getpid()) msleep(1);
> > 	/* malicious code here */
> > 
> 
> This would only be dangerous if the parent did not wait for the child to
> finish its task before changing its uid, which for a FastCGI app, it has
> to as it needs the response to send back to the client. All that would
> happen here is the CGI script would sleep forever, or until the HTTP
> server killed the process.

Thus providing me with a way to DoS your webserver by sticking all your
server processes into a sleep-forever... :)

You're also overlooking the fact that the malicious code could do something
like this:

	/* send the parent something that makes it *think* the request finished */
	printf("We're all done now\n");
	while (getpid()) msleep (1);

Remember - whatever the child is doing to signal that it's done, can *also*
be done by the exploit code. There's only one real exception - the child
can call exit() - if the exploit exits so a SIGCHLD is generated, then
it can't run anymore.  However, since the whole *point* here is avoiding
the usual exit/fork/exec overhead...

--==_Exmh_1228448127_3727P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJOKF/cC3lWbTT17ARAgRBAKCaURqGDRB+4D5Nje+q7QJm4MjbtACg+dHI
ODZ3qpjL1IR+q+3GweQPGmI=
=T7LV
-----END PGP SIGNATURE-----

--==_Exmh_1228448127_3727P--
