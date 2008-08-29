Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbYH2RDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbYH2RDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYH2RC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:02:59 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54327 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbYH2RC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:02:58 -0400
Message-ID: <48B82B2A.6010806@novell.com>
Date: Fri, 29 Aug 2008 13:00:26 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] seqlock: serialize against writers
References: <20080829154237.1196.66825.stgit@dev.haskins.net> <87abevpzv7.fsf@basil.nowhere.org> <48B81F60.3080409@gmail.com> <20080829162216.GW26610@one.firstfloor.org> <48B82349.1020109@gmail.com> <alpine.DEB.1.10.0808291233280.17917@gandalf.stny.rr.com> <48B8254D.1010206@gmail.com> <20080829164551.GY26610@one.firstfloor.org> <alpine.DEB.1.10.0808291251510.17917@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808291251510.17917@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF4DBF2361103993097DC0399"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF4DBF2361103993097DC0399
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Steven Rostedt wrote:
> The subject forgot to add "RT" in the brackets.
>
> On Fri, 29 Aug 2008, Andi Kleen wrote:
>
>  =20
>>> I could just force all of the seqbegins to hit the slowpath by hackin=
g
>>> the code and see what happens (aside from slowing down, of course ;)
>>>      =20
>> Only if you don't believe it will really crash? I think it's pretty
>> clear even without trying it.
>>
>>    =20
>>> Question: Which seqlock_t does userspace use?  I assume it uses
>>> seqlock_t and not raw_seqlock_t.=20
>>>      =20
>>> But the only reason that I ask is that
>>> I converted raw_seqlock_t to use the new style as well to be consiste=
nt,
>>>      =20
>> There's no raw_seqlock_t anywhere in mainline?
>>    =20
>
> Nope, raw_seqlock_t in -rt is equivelant to seqlock_t in mainline.
>
>  =20
>> Anyways the variable is declared (in mainline) in asm-x86/vgtod.h=20
>>
>>    =20
>>> even though it is not strictly necessary for the same reasons.  So if=

>>> perchance userspace uses the raw variant, I could solve this issue by=

>>> only re-working the seqlock_t variant.  Kind of a long shot, but figu=
red
>>> I would mention it :)
>>>      =20
>> I guess you could define a new seqlock_t which is explicitely user spa=
ce
>> safe. That might avoid such issues in the future. But then
>> that would likely require some code duplication and be ugly.
>>
>> On the other hand whatever problem you fixing in the kernel
>> (to be honest it's still unclear to me what the problem is)
>> needs to be likely fixed for the userland lock too.
>>    =20
>
> I'm not convinced that the raw_seqlocks (mainline normal seqlocks) has =
a=20
> problem anyway.
>  =20
(continuing from IRC)

Agreed.   I converted them to be consistent.  Steve just told me that
userspace actually uses the raw_seqlock_t variant, so the answer is
simple.  Just leave raw_seqlock_t alone and the patch will work fine.

Thoughts?

-Greg



--------------enigF4DBF2361103993097DC0399
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki4KyoACgkQlOSOBdgZUxlt7ACggWsLsaxeN6P+UEblZyFrORv4
Zy0An0zODsB09V2r29WLHyxRa8MLzXu8
=2cBr
-----END PGP SIGNATURE-----

--------------enigF4DBF2361103993097DC0399--
