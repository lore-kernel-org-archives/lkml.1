Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYKERqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYKERqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYKERqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:46:12 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:12110 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYKERqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:46:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=bprNTLoIymKoM03bwtqDwO6xSO/ZzVUxXYbkR3rM+rHG5OnaP7T10xTADVFVnoypIC
         Lrvmy8h6w8kftNTYYraRJaZ6BJrDcVGuyRJN33D8wNOXynvkJTA6D2IzADV+ucHNY2HD
         /Zjv6ICFRhDhSxHVPENLYv5aoHvUmUeGVGvwA=
Message-ID: <4911DCEF.80904@gmail.com>
Date: Wed, 05 Nov 2008 19:50:39 +0200
From: "Eugene V. Lyubimkin" <jackyf.devel@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       Chris Friesen <cfriesen@nortel.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: mmap: is default non-populating behavior stable?
References: <490F73CD.4010705@gmail.com> <1225752083.7803.1644.camel@twins> <490F8005.9020708@redhat.com> <491070B5.2060209@nortel.com> <1225814820.7803.1672.camel@twins> <20081104162820.644b1487@lxorguk.ukuu.org.uk> <49107D98.9080201@gmail.com> <Pine.LNX.4.64.0811051613400.21353@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0811051613400.21353@blonde.site>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1779C908F458D7278E2B3061"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1779C908F458D7278E2B3061
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hugh Dickins wrote:
>> Thanks to all for answers. I have made the conclusion that doing "open=
() new
>> file, truncate(<big size>), mmap(<the same big size>), write/read some=
 memory
>> pages" should not populate other, untouched by write/read pages (until=

>> MAP_POPULATE given), right?
[snip]
> For a start, it depends on the filesystem: I believe that vfat, for
> example, does not support the concept of sparse files (files with holes=

> in), so its truncate(<big size>) will allocate the whole of that big
> size initially.
For my case vfat is not an option fortunately.

> I'm not sure what you mean by "populate": in mm, as in MAP_POPULATE,
> we're thinking of prefaulting pages into the user address space; but
> you're probably thinking of whether the blocks are allocated on disk?
Yes.

>>From time to time we toy with prefaulting adjacent pages when a fault
> occurs (though IIRC tests have proved disappointing in the past): we'd
> like to keep that option open, but it would go against your guidelines
> above to some extent.
It depends how is "adjacent" would count :) If several pages, probably no=
t. If
millions or similar, that would be a problem. It's very convenient to use=
 such
"open+truncate+mmap+write/read" behavior to make self-growing-on-demand c=
ache
in memory with disk as back-end without remaps.

Thanks for descriptive answer.

--=20
Eugene V. Lyubimkin aka JackYF


--------------enig1779C908F458D7278E2B3061
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkkR3PAACgkQchorMMFUmYz9cgCcDDqMGI69huraAJHBt+ssF2N7
UxYAn1JFAEi761G9t6NsfAreONhKoMis
=apcv
-----END PGP SIGNATURE-----

--------------enig1779C908F458D7278E2B3061--
