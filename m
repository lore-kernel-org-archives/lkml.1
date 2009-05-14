Return-Path: <linux-kernel-owner+w=401wt.eu-S1761948AbZENNNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761948AbZENNNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbZENNM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:12:57 -0400
Received: from mail-qy0-f133.google.com ([209.85.221.133]:41723 "EHLO
	mail-qy0-f133.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbZENNMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:12:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=cEWCZl0GhX/2qlrOzOTiPRugT9quCj9y/U7+m/ERjnU4KWgqVe3qwpPuzZccJlgWvF
         Qiou2HzRg5HPmYWrqNJe10xyATzHrV1nC5zPPdg6j7lxzL8BVCg0gRXYwIn4Wl2E5D//
         mAwl48wrO7KHosYTYRxhJKSI6lM/z8zsU3DlM=
Message-ID: <4A0C18D3.6060905@gmail.com>
Date: Thu, 14 May 2009 09:12:51 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v7 2/3] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090512181134.26131.10023.stgit@dev.haskins.net> <20090512182655.26131.53824.stgit@dev.haskins.net> <4A0BE8CA.7080801@redhat.com> <4A0C060D.2060107@novell.com> <4A0C0C96.6050600@redhat.com>
In-Reply-To: <4A0C0C96.6050600@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig91B055B0CDDCA6222CF934EC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig91B055B0CDDCA6222CF934EC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>>> Please fget() the new fd and compare the filps; fds aren't meaningful=

>>> in the kernel.  You can also drop _irqfd::fd.
>>>    =20
>>
>> I like this as a second option...
>>
>> =20
>>> It may also be useful to compare the gsi, this allows a
>>> "make-before-break" switchover:
>>>    =20
>>
>> ...but I like this best.  Good idea.
>>  =20
>
> I thought of comparing both.

Ah, ok.  I misunderstood.  We can do that.
>
>>> - guest reroutes irq to a different gsi
>>> - associate irqfd with new gsi
>>> - disassociate irqfd from old gsi
>>>
>>>   =20
>>>> +
>>>> +        irqfd_release(irqfd);
>>>> +        mutex_unlock(&kvm->lock);
>>>> +        return 0;
>>>>        =20
>>> Don't return, userspace may have multiple associations?
>>>    =20
>>
>> Parse error.  Can you elaborate?
>>
>>  =20
>
> You break out of the look when you match your irqfd.  But there may be
> multiple matches.
>
> Granted, it doesn't make much sense to hook the same fd to the same
> gsi multiple times (it may make sense to hook multiple fds to a single
> gsi, or maybe a single fd to multiple gsis), but it pays to have a
> consistent do-what-I-said-even-if-it-doesn't-make-sense interface.

Ack, will do.

-Greg



--------------enig91B055B0CDDCA6222CF934EC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoMGNMACgkQP5K2CMvXmqH+ZwCaAwua+QFa10rkRUv82urB6j4t
AKMAn0ZN78TGawuBY0CuF+8xICI0O11z
=YGdk
-----END PGP SIGNATURE-----

--------------enig91B055B0CDDCA6222CF934EC--
