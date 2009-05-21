Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbZEUN0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbZEUN0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZEUN0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:26:21 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43531 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZEUN0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:26:20 -0400
Message-ID: <4A155669.4010506@novell.com>
Date: Thu, 21 May 2009 09:26:01 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: fix irqfd build failure discovered in linux-next
References: <20090521172122.bb12027c.sfr@canb.auug.org.au> <20090521130426.22997.77787.stgit@dev.haskins.net> <4A1552B1.3040502@redhat.com>
In-Reply-To: <4A1552B1.3040502@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE7F468B9E155A830EF7A153B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE7F468B9E155A830EF7A153B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> Stephen Rothwell noted a build failure in arch !=3D x86 in last nights=

>> linux-next tree, as noted here:
>>
>> http://lkml.org/lkml/2009/5/21/32
>>
>> This patch corrects the build issue by requiring explicit support for
>> IRQFD to be defined, and only defining it on x86 (the only arch fully
>> supported).  The code itself isnt architecture dependent, but we need
>> to add a new file to each makefile, advertise the capability, and
>> of course, test that it works for each supported arch.  We will submit=

>> patches against each relevant arch at a later time to enable support
>> there as well.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> ---
>>
>>  arch/x86/kvm/Makefile    |    1 +
>>  include/linux/kvm_host.h |   17 +++++++++++++++++
>>  virt/kvm/eventfd.c       |    6 ++++++
>>  virt/kvm/kvm_main.c      |    2 +-
>>  4 files changed, 25 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
>> index 01e3c61..e5ce95e 100644
>> --- a/arch/x86/kvm/Makefile
>> +++ b/arch/x86/kvm/Makefile
>> @@ -1,5 +1,6 @@
>> =20
>>  EXTRA_CFLAGS +=3D -Ivirt/kvm -Iarch/x86/kvm
>> +EXTRA_CFLAGS +=3D -DKVM_HAVE_EVENTFD
>> =20
>>  =20
>
> The standard idiom for this is to use a Kconfig symbol; see for
> example HAVE_KVM_IRQCHIP in arch/*/kvm/Kconfig.

Ah, I didn't realize I could do this in such a contained manner.  I was
afraid of polluting the top level arch/Kconfig, which is why I went this
other route.   But I see from your example that this is not the case.  I
will make a v2 with this change.

-Greg

>
>



--------------enigE7F468B9E155A830EF7A153B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoVVm0ACgkQlOSOBdgZUxlreACeM/0UuXlqL8OsuAo4RtJrh7tz
avUAnivR12hwWzJmQnxhRNbObsxj2VHo
=W/KW
-----END PGP SIGNATURE-----

--------------enigE7F468B9E155A830EF7A153B--
