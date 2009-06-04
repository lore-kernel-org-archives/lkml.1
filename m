Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZFDLoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZFDLoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZFDLoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:44:11 -0400
Received: from mail-qy0-f200.google.com ([209.85.221.200]:41752 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbZFDLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:44:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=xa9ngXBOISPn4GFZurKmHqyCaKNRjqgelR2nxGZ34whvOK4HB8/JBCB16dCDFdt8/G
         Qa6g4CoZzR/Epip4VXqoBv10fZeO9L9GiytCQstvLVd+y4q4fqfWWG5PVGr2AHimVwMG
         HExCga+nJfLvOAjS3F3QDr6V9mCUIx/0LTCkM=
Message-ID: <4A27B37F.1060307@gmail.com>
Date: Thu, 04 Jun 2009 07:43:59 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [KVM-RFC PATCH 0/2] irqfd: use POLLHUP notification for close()
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602160434.GA6827@redhat.com> <4A254FD7.5090302@novell.com> <20090602162021.GB6827@redhat.com> <4A255484.6060401@novell.com> <20090602165949.GD6827@redhat.com> <4A256431.2080101@novell.com> <20090603063956.GA8134@redhat.com> <4A27A10C.2050405@redhat.com>
In-Reply-To: <4A27A10C.2050405@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig455CD13D7B9610358673AFBE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig455CD13D7B9610358673AFBE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Michael S. Tsirkin wrote:
>> On Tue, Jun 02, 2009 at 01:41:05PM -0400, Gregory Haskins wrote:
>> =20
>>>> And having close not clean up the state unless you do an ioctl
>>>> first is
>>>> very messy IMO - I don't think you'll find any such examples in
>>>> kernel.
>>>>
>>>>        =20
>>> I agree, and that is why I am advocating this POLLHUP solution.  It w=
as
>>> only this other way to begin with because the technology didn't exist=

>>> until Davide showed me the light.
>>>
>>> Problem with your request is that I already looked into what is
>>> essentially a bi-directional reference problem (for a different reaso=
n)
>>> when I started the POLLHUP series.  Its messy to do this in a way tha=
t
>>> doesn't negatively impact the fast path (introducing locking, etc) or=

>>> make my head explode making sure it doesn't race.  Afaict, we would
>>> need
>>> to solve this problem to do what you are proposing (patches welcome).=

>>>
>>> If this hybrid decoupled-deassign + unified-close is indeed an
>>> important
>>> feature set, I suggest that we still consider this POLLHUP series for=

>>> inclusion, and then someone can re-introduce DEASSIGN support in the
>>> future as a CAP bit extension.  That way we at least get the desirabl=
e
>>> close() properties that we both seem in favor of, and get this advanc=
ed
>>> use case when we need it (and can figure out the locking design).
>>>
>>>    =20
>>
>> FWIW, I took a look and yes, it is non-trivial.
>> I concur, we can always add the deassign ioctl later.
>>  =20
>
> I agree that deassign is needed for reasons of symmetry, and that it
> can be added later.
>
Cool.

FYI: Davide's patch has been accepted into -mm (Andrew CC'd).  I am not
sure of the protocol here, but I assume this means you can now safely
pull it from -mm into kvm.git so the prerequisite for 2/2 is properly met=
=2E

-Greg


--------------enig455CD13D7B9610358673AFBE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkons4QACgkQP5K2CMvXmqGPQQCfYjfZaVjDSxRtvYY9b0SKyDCK
7GoAn2Y3fxC+4qPtljfwF/4wBVCgUJnF
=mcd8
-----END PGP SIGNATURE-----

--------------enig455CD13D7B9610358673AFBE--
