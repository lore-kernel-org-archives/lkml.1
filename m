Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZFYO4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZFYO4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZFYO4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:56:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:21026 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZFYO4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:56:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=Ge/iQbrJxdLi26ir0Ru244q1R0oEhELDfKpZB9CeG1gwYUBsT9xJPN1qI3mrqO6viK
         E7jGwNris1RlSagbLsauX1CmhKQlJPXRqE7BIkf8/qXzF3TedC93VuSuznE72JeV2wA7
         qei1bZXvYhLFFc1X7Em/jtmv2en0rSjk2lN4s=
Message-ID: <4A439029.10601@gmail.com>
Date: Thu, 25 Jun 2009 10:56:41 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 1/3] KVM: make io_bus interface more robust
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003035.15859.33528.stgit@dev.haskins.net> <4A438825.5000606@novell.com> <20090625145341.GC7221@redhat.com>
In-Reply-To: <20090625145341.GC7221@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig226247ED22B143150E7089D1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig226247ED22B143150E7089D1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 25, 2009 at 10:22:29AM -0400, Gregory Haskins wrote:
>  =20
>> Gregory Haskins wrote:
>>    =20
>>> Today kvm_io_bus_regsiter_dev() returns void and will internally BUG_=
ON if it
>>> fails.  We want to create dynamic MMIO/PIO entries driven from usersp=
ace later
>>> in the series, so we need to enhance the code to be more robust with =
the
>>> following changes:
>>>
>>>    1) Add a return value to the registration function
>>>    2) Fix up all the callsites to check the return code, handle any
>>>       failures, and percolate the error up to the caller.
>>>    3) Add an unregister function that collapses holes in the array
>>>      =20
>
> Does not unregister need rcu bus fixes to work?
>
>  =20
Not without users ;)

But, hmm.   Perhaps I should re-split out the return value stuff so it
can go independent of the unregister.  Gah, this io_bus is a nightmare.

-Greg


--------------enig226247ED22B143150E7089D1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpDkCkACgkQP5K2CMvXmqE+TwCcCB/YlHBHgodDVf3XLHE4TqjF
91wAn39g+FNtW5nPSYjfFyR1x3rdJ+9t
=myHr
-----END PGP SIGNATURE-----

--------------enig226247ED22B143150E7089D1--
