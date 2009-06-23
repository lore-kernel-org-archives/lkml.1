Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbZFWQOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbZFWQOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759574AbZFWQOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:14:09 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35842 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396AbZFWQOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:14:07 -0400
Message-ID: <4A40FF48.8030604@novell.com>
Date: Tue, 23 Jun 2009 12:14:00 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
References: <20090623150008.GA21059@redhat.com> <4A40F311.80105@novell.com> <20090623153144.GA21423@redhat.com> <4A40F879.3040408@novell.com> <20090623155607.GB21423@redhat.com>
In-Reply-To: <20090623155607.GB21423@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1603DD27E4DC41E7D818E071"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1603DD27E4DC41E7D818E071
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 23, 2009 at 11:44:57AM -0400, Gregory Haskins wrote:
>  =20
>>>>  This proposed approach forces us into a
>>>> potential O(256) algorithm in the hotpath (all MMIO/PIO exits will h=
it
>>>> this, not just in-kernel users).  How would you address this?
>>>>    =20
>>>>        =20
>>> Two ideas that come to mind:
>>> - add addr/len fields to devices, use these to speed up lookup
>>>  =20
>>>      =20
>> Yep, thats what I was thinking as well.  We can have the top-level
>> (group) be an rbtree on addr/len, and then walk the list of items at
>> that address linearly using your read/write() approach.
>>
>>
>>    =20
>>> - add a small cache that can be scanned first
>>>  =20
>>>      =20
>> Yep, I think we may want to do this anyway independent of the search a=
lg.
>>
>>    =20
>>> In both cases, you first do a fast lookup, ask the device whether
>>> it wants the transaction, then resort to linear scan if not
>>>  =20
>>>      =20
>> -Greg
>>
>>    =20
>
> Looks like we have a concensus then.
>
>  =20

Yep.  I'll try to go over the patch in detail today and provide any more
feedback.

Thanks Michael,
-Greg


--------------enig1603DD27E4DC41E7D818E071
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpA/0gACgkQlOSOBdgZUxn4gwCePQBeYwkFlIiBxptT4iCUDrK4
AJMAni6Tj6taaRaveaxRdurt9N2I/d3N
=w6/k
-----END PGP SIGNATURE-----

--------------enig1603DD27E4DC41E7D818E071--
