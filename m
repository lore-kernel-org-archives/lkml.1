Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZFBQOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZFBQOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZFBQOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:14:22 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36031 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbZFBQOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:14:22 -0400
Message-ID: <4A254FD7.5090302@novell.com>
Date: Tue, 02 Jun 2009 12:14:15 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 0/2] irqfd: use POLLHUP notification for close()
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602160434.GA6827@redhat.com>
In-Reply-To: <20090602160434.GA6827@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig358DB68B82E720B672CCCD90"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig358DB68B82E720B672CCCD90
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 02, 2009 at 11:15:28AM -0400, Gregory Haskins wrote:
>  =20
>> (Applies to kvm.git/master:25deed73)
>>
>> Please see the header for 2/2 for a description.  This patch series ha=
s
>> been fully tested and appears to be working correctly.  I have it as a=
n RFC
>> for now because it needs Davide's official submission/SOB for patch 1/=
2, and
>> it should get some eyeballs/acks on my SRCU usage before going in.
>>
>> I will submit the updated irqfd userspace which eschews the deassign()=
 verb
>> since we can now just use the close(fd) method alone.  I will also add=
ress
>> the userspace review comments from Avi.
>>    =20
>
>
> We are not killing the deassign though, do we?
>  =20

Yes, it is not needed any more now that we have proper
release-notification from eventfd.

> It's good to have that option e.g. for when we pass
> the fd to another process.
>  =20

Passing the fd to another app should up the underlying file reference
count.  If the producer app wants to "deassign" it simply calls
close(fd) (as opposed to today where it calls DEASSIGN+close), but the
reference count will allow the consuming app to leave the eventfd's file
open.  Or am I misunderstanding you?

-Greg



--------------enig358DB68B82E720B672CCCD90
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkolT9sACgkQlOSOBdgZUxkQTwCfUtobQKbApxMzQhQIdQSFmHfl
sYYAoIUtqLM3+w8LyRNr4MDaLjKBT4Kn
=dd/g
-----END PGP SIGNATURE-----

--------------enig358DB68B82E720B672CCCD90--
