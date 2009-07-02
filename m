Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbZGBO10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbZGBO10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZGBO1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:27:17 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43637 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbZGBO1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:27:16 -0400
Message-ID: <4A4CC3B4.7060109@novell.com>
Date: Thu, 02 Jul 2009 10:27:00 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v8 1/3] KVM: Fix races in irqfd using new eventfd_kref_get
 interface
References: <20090701160208.3615.99153.stgit@dev.haskins.net> <20090701160902.3615.39426.stgit@dev.haskins.net> <4A4CC14C.1000905@redhat.com>
In-Reply-To: <4A4CC14C.1000905@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2AFF6DD0EBB5DAEE97715E8D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2AFF6DD0EBB5DAEE97715E8D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 07/01/2009 07:09 PM, Gregory Haskins wrote:
>> eventfd currently emits a POLLHUP wakeup on f_ops->release() to
>> generate a
>> "release" callback.  This lets eventfd clients know if the eventfd is
>> about
>> to go away and is very useful particularly for in-kernel clients.=20
>> However,
>> until recently it is not possible to use this feature of eventfd in a
>> race-free way.
>>
>> This patch utilizes a new eventfd interface to rectify the problem.=20
>> It also
>> converts the eventfd POLLHUP generation code to use the locked variant=

>> of wakeup.
>>
>> Signed-off-by: Gregory Haskins<ghaskins@novell.com>
>> CC: Davide Libenzi<davidel@xmailserver.org>
>> ---
>>
>>   fs/eventfd.c             |    7 --
>>   include/linux/kvm_host.h |    5 +
>>   virt/kvm/eventfd.c       |  187
>> ++++++++++++++++++++++++++++++++--------------
>>   3 files changed, 134 insertions(+), 65 deletions(-)
>>   =20
>
>
> Please split the eventfd.c hunk into a separate patch.  When preparing
> the 2.6.32 submission, I'll fold that into the patch into its
> antipatch and they'll disappear.
>
Ok, but note that that means I should probably split 1/3 back out into
1/5 (prepare), 2/5 (eventfd hunk), 3/5 (fix irqfd) again like I had in
v7 so that the series is bisectable.  Is that ok?

-Greg


--------------enig2AFF6DD0EBB5DAEE97715E8D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpMw7gACgkQlOSOBdgZUxnjsgCghbwatTjbiCf1sOLuGha3PZrV
Z90AoIr6vqtbpgxLk9IbzoCA60j5IhdF
=zevp
-----END PGP SIGNATURE-----

--------------enig2AFF6DD0EBB5DAEE97715E8D--
