Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbZENMCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbZENMCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbZENMC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:02:28 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48012 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbZENMC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:02:27 -0400
Message-ID: <4A0C084F.3040706@novell.com>
Date: Thu, 14 May 2009 08:02:23 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v7 3/3] kvm: add iofd support
References: <20090512181134.26131.10023.stgit@dev.haskins.net> <20090512182701.26131.66801.stgit@dev.haskins.net> <4A0BFC56.9090601@redhat.com>
In-Reply-To: <4A0BFC56.9090601@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5B3EEE4B3E43B94D0774A651"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5B3EEE4B3E43B94D0774A651
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> iofd is a mechanism to register PIO/MMIO regions to trigger an eventfd=

>> signal when written to.  Userspace can register any arbitrary address
>> with a corresponding eventfd.
>>
>>  =20
>
> Please start a separate patchset for this so I can merge irqfd.

Ack.  Will spin a new split series with your irqfd review changes
>
>>
>> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
>> index dfc4bcc..99b6e45 100644
>> --- a/include/linux/kvm.h
>> +++ b/include/linux/kvm.h
>> @@ -292,6 +292,17 @@ struct kvm_guest_debug {
>>      struct kvm_guest_debug_arch arch;
>>  };
>> =20
>> +#define KVM_IOFD_FLAG_DEASSIGN  (1 << 0)
>> +#define KVM_IOFD_FLAG_PIO       (1 << 1)
>> +
>> +struct kvm_iofd {
>> +    __u64 addr;
>> +    __u32 len;
>> +    __u32 fd;
>> +    __u32 flags;
>> +    __u8  pad[12];
>> +};
>> +
>>  =20
> Please add a data match capability.  virtio uses a write with the data
> containing the queue ID, and we want a separate event for each queue.

How about "u64 cookie" ?
>
>
>>   * kvm trace categories
>> @@ -508,6 +519,7 @@ struct kvm_irqfd {
>>  #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct
>> kvm_assigned_irq)
>>  #define KVM_ASSIGN_IRQFD           _IOW(KVMIO, 0x76, struct kvm_irqfd=
)
>>  #define KVM_DEASSIGN_IRQFD         _IOW(KVMIO, 0x77, __u32)
>> +#define KVM_IOFD                   _IOW(KVMIO, 0x78, struct kvm_iofd)=

>>  =20
>
> Too general a name.  It's not doing IO, just sending out notifications.=


Hmm...good point.  I was trying to reflect "[MM/P]IO-FD".  How about
"IOSIGNALFD"

>
> Why have assign/deassign for irqfd and a single ioctl for iofd?
Heh..  irqfd "liked" two because the deassign only needed a u32.  iofd
needed more or less the same structure for both so I guess I thought I
would be "slick" and condense the vectors.  Will fix so they are
symmetrical.

>
> The rest looks good.
>

I will also submit a patch to fix the io_bus stuff so that registrations
can gracefully fail instead of BUG_ON(), and to provide an unregister
function.

Thanks Avi,
-Greg


--------------enig5B3EEE4B3E43B94D0774A651
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoMCE8ACgkQlOSOBdgZUxnCfQCfUDHRFsYSm8uriR8CyvX/7IY7
6F8AmgLz58kYFptEB9uXl97+xAHNsDtA
=ahQc
-----END PGP SIGNATURE-----

--------------enig5B3EEE4B3E43B94D0774A651--
