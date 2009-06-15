Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZFOEZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZFOEZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbZFOEZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:25:42 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:57522 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZFOEZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:25:41 -0400
Message-ID: <4A35CD41.20206@novell.com>
Date: Mon, 15 Jun 2009 00:25:37 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com, markmc@redhat.com,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [KVM PATCH v6 2/2] KVM: add iosignalfd support
References: <20090605154006.18047.41232.stgit@dev.haskins.net> <20090605155508.18047.83818.stgit@dev.haskins.net> <4A29417A.6070706@novell.com> <20090613043951.GA3083@amt.cnet>
In-Reply-To: <20090613043951.GA3083@amt.cnet>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig936278FE70A44E04EA618519"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig936278FE70A44E04EA618519
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Marcelo,

Marcelo Tosatti wrote:
> On Fri, Jun 05, 2009 at 12:02:02PM -0400, Gregory Haskins wrote:
>  =20
>> Hi Marcelo!
>>
>> Comments about the shutdown path ambiguity are in-line
>>
>> Gregory Haskins wrote:
>>    =20
>>> iosignalfd is a mechanism to register PIO/MMIO regions to trigger an =
eventfd
>>> signal when written to by a guest.  Host userspace can register any a=
rbitrary
>>> IO address with a corresponding eventfd and then pass the eventfd to =
a
>>> +		list_del(&item->list);
>>> +		iosignalfd_item_free(item);
>>> +	}
>>> +
>>> +	list_del(&group->list);
>>> +	kfree(group);
>>> +}
>>>  =20
>>>      =20
>> So this function is called by the path that executes as we do the last=

>> kvm_put_kvm().  I do not do any careful RCU wrangling here because I
>> assume that there cannot possibly be any active MMIO/PIO operations at=

>> this time, or the reference would never have dropped.  Let me know if
>> anyone sees any holes in that.
>>
>> An alternative approach is to do this similar to how irqfd_release()
>> works.   That is: invoke it from the vmfd release() path instead of th=
e
>> the kvm object destructor.  I currently do not think this is necessary=
,
>> but I will throw that out there in case someone likes it better.
>>    =20
>
> Gregory,
>
> Can't see any problems with it.

Thanks for the review!


>  You might want an upper limit
> in the number of items per group.
>  =20


Yeah, I agree that is a good idea.  Will fix in v7.

BTW: Did your series get merged while I was away?

-Greg


--------------enig936278FE70A44E04EA618519
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko1zUEACgkQlOSOBdgZUxkOCgCfRiMXmjvviRnyQdd6DTNWjP0c
3awAn0mG1e7CTXqgrILdVlR3Mc+DxvGJ
=piPC
-----END PGP SIGNATURE-----

--------------enig936278FE70A44E04EA618519--
