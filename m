Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZKQODv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZKQODv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZKQODu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:03:50 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:47900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZKQODt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:03:49 -0500
Subject: Re: [PATCH 17/21] workqueue: simple reimplementation of
 SINGLE_THREAD workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
In-Reply-To: <1258391726-30264-18-git-send-email-tj@kernel.org>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>
	 <1258391726-30264-18-git-send-email-tj@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gmc/jyTFaXo49pE0UzlE"
Date: Tue, 17 Nov 2009 15:03:17 +0100
Message-ID: <1258466597.3682.11.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gmc/jyTFaXo49pE0UzlE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-17 at 02:15 +0900, Tejun Heo wrote:
> SINGLE_THREAD workqueues are used to reduce the number of worker
> threads and ease synchronization.

Wireless (mac80211) also requires that the order in which different work
structs are queued up is identical to the processing order. At least
some code was written with that assumption in mind, and I think it's
actually required in a few places.

Also, that unlikely() here:

> +	if (unlikely(single_thread)) {
> +		mutex_lock(&wq->single_thread_mutex);
> +		f(work);
> +		mutex_unlock(&wq->single_thread_mutex);
> +	} else
> +		f(work);

seems wrong, there are many single-threaded workqueues after all.

johannes

--=-gmc/jyTFaXo49pE0UzlE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAq0hAAoJEODzc/N7+QmajdEQAM+alZuHoeG8zldGHjYvhqkP
MO862E2/g1UuQqBXL85lRBrm6tlnIF64PHAD2Q49L1zw9ZkzDdZTUM9lEJAHJ1ff
Mfvco1phEjObEXYPBMueVF6rs26yKt6PCIst40MRvEUnB4LpU/kP+2sV3W7iKwBk
Qcx1dg0h4LVjyuXKOom8BjlTCcFbPsKEHPhSTaKoPpHmObq8GCcB1Z3z7DT4abI9
r/BqfbkRU6qEkuwWsKQMKkklZSc3UoPlJ8Rk8SM1vQ+gLhaV/OR8mapycwHtlDKG
OZeuekySJHmic7SFiyC0r5lQMbka1mRPZpnxXihcAzit9E9exE9DL4gkyhw/A6Wv
YbTV759Rou5jVM1czZn2gcMlEGy8VnGwD4/2u9jaxeWX6x4ywndM+/QmUrHwpqWa
Dz+TA0geR41bnNruz/w6IWK9lGaq+dmpwaNhMEbsSw7UO+KSE99bFacUkXFRd5JD
LBrEw8eR4YXp513oyyCEgz+n5NrdO1cT6GcKTFJL299ZoZ8AaMG/hc1SbisOAkor
X57yFZxw/V5bL49TMOFRFu4cAnFOr+4JDUC6qNAjI0E3bRUw43xv2zchPy7ZcYyM
MRY6VZbNkdv6k/UdF/UzXzco9MaUmI27sg6u6js+PS20fiR6WR3knQX3gk2lZK8l
AmTZa0OsFmD41V610NYR
=RMtT
-----END PGP SIGNATURE-----

--=-gmc/jyTFaXo49pE0UzlE--

