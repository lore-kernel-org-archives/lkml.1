Return-Path: <linux-kernel-owner+w=401wt.eu-S939855AbXHNCGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939855AbXHNCGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 22:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXHNCGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 22:06:45 -0400
Received: from mailgate-out2.mysql.com ([213.136.52.68]:38813 "EHLO
	mailgate.mysql.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750860AbXHNCGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 22:06:43 -0400
X-Greylist: delayed 1314 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 22:06:43 EDT
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
From: Stewart Smith <stewart@mysql.com>
To: Brice Figureau <brice+lklm@daysofwonder.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1186389638.30448.29.camel@localhost.localdomain>
References: <20070803123712.987126000@chello.nl>
	 <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	 <20070804063217.GA25069@elte.hu> <loom.20070805T190600-28@post.gmane.org>
	 <p734pjdmxsz.fsf@bingen.suse.de>
	 <1186389638.30448.29.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+pjuwmzVbFesPQ352XO7"
Organization: MySQL AB
Date: Tue, 14 Aug 2007 11:44:56 +1000
Message-Id: <1187055897.18858.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+pjuwmzVbFesPQ352XO7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 10:40 +0200, Brice Figureau wrote:
> Mysql accesses its database files in O_DIRECT mode.

binlog is written using buffered IO.

for InnoDB, binlog is synced first, then innodb log. on restart (in 5.0)
these are synced back up so you don't get inconsistencies.

and from a quick look at the innobase source, only data file is using
O_DIRECT.

> Since the database fits in RAM, the only kind of access Mysql is doing
> is writing to the innodb log, the mysql binlog and finally to the innodb
> database files.
> There are certainly a whole lot of fsync'ing happening.

yes. Keep in mind that the binlog grows in file size too... so this has
to sync all the metadata as well (ick, i know).
--=20
Stewart Smith, Senior Software Engineer
MySQL AB, www.mysql.com
Office: +14082136540 Ext: 6616
VoIP: 6616@sip.us.mysql.com
Mobile: +61 4 3 8844 332

Jumpstart your cluster:
http://www.mysql.com/consulting/packaged/cluster.html

--=-+pjuwmzVbFesPQ352XO7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQIVAwUARsEJGL3yNwHyU3DLAQIJAQ//XsnJ0jQvxuPPT48LIJoeBX2eejc0ISVs
3aN+5mMkIy/nI8LlfUNfmsCCCWwo5j2Mj/AHG+gtM3F2xWOYqfnX0dAg9kJRu3j4
lctPzQ/aj4qhBQ8FBHnH7i0vfvN/ydxs1u8ebBiqDYl0djukt74pBJBNuKAd8zK6
IbfqJcew8T/25+zVxz7rfZF6ghmh+TlgglYikM3tJs61ZK7SS0We9ZHo0L98pG7U
MXMDBrQIZ2+Xoe/vRXTkYhkYHGd5p8JnXFBUTtY8C8harPglyyDjbIeI2VGFN5mZ
taYqhbUnfnHgf3WoXSzaN336GCqa/nII1n0XiSU53kk4UTKtgYUQLZchTATV1UBQ
ZG1keeb/2MNsIHcMwrRJfwV/Omv+1Gi0dzxM7JQQap0CJX86vkL7L2O37nvOxXto
UABErSKU4e/2TMPtOVgaPAnh9ZzKgPUsI/qiXxeWWHrzIDZX3MPmjOmpDQSVj1a+
O6Uhb9YjhPk9nO/juyxd8pSez+lwmRnfBrm5gXqmtamcdyDL/+UzdOnq4F+6gbS1
sO8ksnSp4DwyE7TuEm2Tq4aguCGX4rqV1SaCFshssJaFVTfR4n8y+wMz2xPaAwoi
C5RKCDL512hY4LXyO0PgtsGgnfAcsomdUX9S39AKFrvkPZJcOPh3aWRWD8DBmaZf
zXnj3BKMlUc=
=WxnS
-----END PGP SIGNATURE-----

--=-+pjuwmzVbFesPQ352XO7--

