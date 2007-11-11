Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbXKKDge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbXKKDge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 22:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXKKDg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 22:36:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:51153 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbXKKDgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 22:36:25 -0500
Date: Sat, 10 Nov 2007 19:36:34 -0800
From: John Johansen <jjohansen@suse.de>
To: david@lang.hm
Cc: Andi Kleen <andi@firstfloor.org>, Crispin Cowan <crispin@crispincowan.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
Message-ID: <20071111033634.GB19216@suse.de>
References: <473380AD.5070801@crispincowan.com> <p73tzntzuak.fsf@bingen.suse.de> <Pine.LNX.4.64.0711101325240.4780@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711101325240.4780@asgard.lang.hm>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 10, 2007 at 01:28:25PM -0800, david@lang.hm wrote:
> On Sat, 10 Nov 2007, Andi Kleen wrote:
>
>> Crispin Cowan <crispin@crispincowan.com> writes:
>>
>> The document should be a good base for a merge.
>>
>>>     * A confined process can operate on a file descriptor passed to it
>>>       by an unconfined process, even if it manipulates a file not in the
>>>       confined process's profile. To block this attack, confine the
>>>       process that passed the file descriptor.
>>
>> That is the only thing that tripped me up a bit while reading the=20
>> document.
>> Can you expand a bit on the reasons why the fd is not rechecked in
>> the context of the target process? Best do it in a new version of the
>> document.
>
> from prior discussions I understand that the problem is that it's not eas=
y=20
> (or nessasarily possible) to figure out the path to the fd, so what do yo=
u=20
> check?
>
> if the file has been removed there _is_ no path to the fd.
>
> with hard links there could be many paths to the fd, the only way to find=
=20
> them would be to search the entire filesystem.
>
> as a result App Armor has decided not to try and address this, but is=20
> documenting it as a limitation.
>
Actually no.  The unconfined fd being passed in is explicitly different
than and fd being passed between two confined processes.  In the
unconfined parent passing an fd into a confined child the fd isn't
reevaluated.  In the case of confined parent to confined child the
the struct file is reevaluated.

As to the implementation issue of revalidation.  The path name to file can
be found as struct file stores both the vfsmnt and dentry.  With that said
there are a couple cases where the pathname can't be found.
- the file has been deleted
- the path has become disconnected.

In short under file revalidation deleted file are given a pass and
disconnected files fail.

For a more in depth explanation look at
http://forgeftp.novell.com//apparmor/LKML_Submission-Oct-07/techdoc.pdf

regards
john


--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQFHNnjCi/GH5xuqKCcRAtQPAJ0WxVwKJH7NiS32xMi9a67g9LchwQCeMV61
A5BnrJi1weOtwdZDGBPQq6s=
=M2Mi
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--
