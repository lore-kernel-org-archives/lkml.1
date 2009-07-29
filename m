Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbZG2NOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbZG2NOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZG2NOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:14:46 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:62716 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbZG2NOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:14:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=a/qHwMMDJLkvkBTjoX4Pbh4n+CLx6hGT8aUQJuOcUuEOqjhuAs75h6GNtsH392pRGV
         Mn3dRsLkIku2HeqZwanw9CDh9qjx4rI5TZmnGMm/FWqqYJIH+wYYN2Ir793LT1hIXLma
         x+qTENYGtiIrOdNRN6mSYZQgQymQSxoG+f4Sc=
Message-ID: <4A704B41.9000505@gmail.com>
Date: Wed, 29 Jul 2009 09:14:41 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] sched: check for pushing rt tasks after all scheduling
References: <20090729042121.727652581@goodmis.org>	 <20090729042526.205923666@goodmis.org> <1248856884.6987.3043.camel@twins>
In-Reply-To: <1248856884.6987.3043.camel@twins>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig48ED802EC797946723AC1513"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig48ED802EC797946723AC1513
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> On Wed, 2009-07-29 at 00:21 -0400, Steven Rostedt wrote:
>> plain text document attachment
>> (0001-sched-check-for-pushing-rt-tasks-after-all-schedulin.patch)
>> From: Steven Rostedt <srostedt@redhat.com>
>>
>> The current method for pushing RT tasks after scheduling only
>> happens after a context switch. But we found cases where a task
>> is set up on a run queue to be pushed but the push never happens
>> because the schedule chooses the same task.
>>
>> This bug was found with the help of Gregory Haskins and the use of
>> ftrace (trace_printk). It tooks several days for both of us analyzing
>> the code and the trace output to find this.
>=20
>=20
>> +               if (current->sched_class->needs_post_schedule)
>> +                       post_schedule =3D current->sched_class->needs_=
post_schedule(rq);
>=20
>=20
>> +       if (post_schedule)
>> +               current->sched_class->post_schedule(rq);
>=20
>=20
> Why can't we omit that first call, and do the second unconditionally,
> using storage in the class rq to save state?

Yeah, that is a good idea.  Plus I see another bug that Steven and I
overlooked.  Steve is out on holiday today, so I will put together a v2.

Regards,
-Greg


--------------enig48ED802EC797946723AC1513
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkpwS0EACgkQP5K2CMvXmqH7qACdHW4dBsojLSkrLWWQlrLh8lW2
1KMAn21+3JzCvpdPpBXJ7s1pv/ANvG3V
=CwKL
-----END PGP SIGNATURE-----

--------------enig48ED802EC797946723AC1513--
