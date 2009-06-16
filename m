Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZFPRB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZFPRB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbZFPRBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:01:18 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42595 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZFPRBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:01:17 -0400
Message-ID: <4A37CFDA.4000602@novell.com>
Date: Tue, 16 Jun 2009 13:01:14 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig73D667C68A7295807E0744F5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig73D667C68A7295807E0744F5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Tue, 16 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> Does this all make sense?
>>    =20
>
> This conversation has been *really* long, and I haven't had time to loo=
k=20
> at the patch yet. But looking at the amount of changes, and the amount =
of=20
> even more changes talked in this thread, there's a very slim chance tha=
t=20
> I'll ACK the eventfd code.
> You may want to consider a solution that does not litter eventfd code t=
hat=20
> much.
>
>
> - Davide
>
>
>  =20
Hi Davide,

I understand your position and value your time/insight into looking at
this things.

Despite the current ongoing discussion, I still stand that the current
patch is my proposed solution (though I have yet to convince Michael).=20
But in any case,  if you have the time, please look it over because I
still think its the right direction to head in.

The general solution is that we use an srcu list instead of the
wait-queue, and thats really it.  If we can't eliminate that spinlock
held over the notification, it has usability implications at least for
irqfd/iosignalfd.  The only way I can think of to solve the problem
without modifying eventfd is to not use eventfd at all.   :(

Since using eventfd really captures the concept we are going for here
really well, reusing it has a ton of advantages including interface
compatibility and, of course, code-reuse of a tested/debugged code
base.  Heck, we may hopefully even improve eventfd for other users in
doing this work.  It would therefore be a shame to walk away from it if
it can be avoided.

So if what I proposed is not acceptable but you are willing to work with
me to find a solution that is, that would be ideal from my perspective.=20
Otherwise, I apologize for all the noise.  You have been quite the
patient and helpful gentleman with me to date and I appreciate that.

Kind Regards,
-Greg


--------------enig73D667C68A7295807E0744F5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko3z9oACgkQlOSOBdgZUxkE5wCePJi+vX/CEa3OK0mQ8K7zV0/g
rOUAnRPuvuAEpXTEQJfEQn2H4dR58Asm
=3FuT
-----END PGP SIGNATURE-----

--------------enig73D667C68A7295807E0744F5--
