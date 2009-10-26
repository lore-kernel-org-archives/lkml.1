Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZJZPiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZJZPiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZJZPiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:38:21 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:39375 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZJZPiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=odlDb0jemst21qtqgr9Mpk093SggyAb5v4jJqXDdiHK9GqHFY5l5LgLCFKdVbogwTH
         wZ18MdwWpiUaU8vj9PIahQ8W8siTk6W2OUCcG0Z0MkkSTHIZK+g9fuhavbEt4nPnJDFl
         sbOh7VV/kJv4GRx/5xQGFitXNdzPTO2qxMuWc=
Message-ID: <4AE5C26A.9000400@gmail.com>
Date: Mon, 26 Oct 2009 11:38:18 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Subject: Re: [Alacrityvm-devel] [KVM PATCH v2 1/2] KVM: export lockless GSI
 attribute
References: <20091023023512.3891.65889.stgit@dev.haskins.net>	<20091023023845.3891.36857.stgit@dev.haskins.net> <4AE460F4.2090905@redhat.com> <4AE5A336.4010801@gmail.com>
In-Reply-To: <4AE5A336.4010801@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDD22D78FF4BC219F9C803553"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDD22D78FF4BC219F9C803553
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Avi Kivity wrote:
>> On 10/23/2009 04:38 AM, Gregory Haskins wrote:
>>> Certain GSI's support lockless injecton, but we have no way to detect=

>>> which ones at the GSI level.  Knowledge of this attribute will be
>>> useful later in the series so that we can optimize irqfd injection
>>> paths for cases where we know the code will not sleep.  Therefore,
>>> we provide an API to query a specific GSI.
>>>
>>>   =20
>> Instead of a lockless attribute, how about a ->set_atomic() method.  F=
or=20
>> msi this can be the same as ->set(), for non-msi it can be a function =

>> that schedules the work (which will eventually call ->set()).
>>
>> The benefit is that we make a decision only once, when preparing the=20
>> routing entry, and install that decision in the routing entry instead =
of=20
>> making it again and again later.
>=20
> Yeah, I like this idea.  I think we can also get rid of the custom
> workqueue if we do this as well, TBD.

So I looked into this.  It isn't straight forward because you need to
retain some kind of state across the deferment on a per-request basis
(not per-GSI).  Today, this state is neatly tracked into the irqfd
object itself (e.g. it knows to toggle the GSI).

So while generalizing this perhaps makes sense at some point, especially
if irqfd-like interfaces get added, it probably doesn't make a ton of
sense to expend energy on it ATM.  It is basically a generalization of
the irqfd deferrment code.  Lets just wait until we have a user beyond
irqfd for now.  Sound acceptable?

In the meantime, I found a bug in the irq_routing code, so I will submit
a v3 with this fix, as well as a few other things I improved in the v2
series.

Kind Regards,
-Greg


--------------enigDD22D78FF4BC219F9C803553
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrlwmoACgkQP5K2CMvXmqHJFgCeLnNFYf/qAAXaJttfbnaXLhFc
rAQAn38DgeeIrTz0MkTWKqgv8vbQa2pp
=07Z5
-----END PGP SIGNATURE-----

--------------enigDD22D78FF4BC219F9C803553--
