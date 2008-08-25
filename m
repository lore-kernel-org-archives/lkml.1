Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYHYKau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYHYKau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYHYKam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:30:42 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:48434 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYHYKam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:30:42 -0400
Date: Mon, 25 Aug 2008 12:30:37 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v2][PATCH 8/9] File descriprtors - dump state
Message-ID: <20080825103037.GB5003@localdomain>
Reply-To: Louis.Rilling@kerlabs.com
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0808202306530.17436@takamine.ncl.cs.columbia.edu> <20080821110614.GK581@hawkmoon.kerlabs.com> <48B226CE.2060700@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-6405-1219660109-0001-2"
Content-Disposition: inline
In-Reply-To: <48B226CE.2060700@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-6405-1219660109-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 24, 2008 at 11:28:14PM -0400, Oren Laadan wrote:
>
>
> Louis Rilling wrote:
>> On Wed, Aug 20, 2008 at 11:07:16PM -0400, Oren Laadan wrote:
>>> Dump the files_struct of a task with 'struct cr_hdr_files', followed by
>>> all open file descriptors. Since FDs can be shared, they are assigned a
>>> tag and registered in the object hash.
>>>
>>> For each open FD there is a 'struct cr_hdr_fd_ent' with the FD, its tag
>>> and its close-on-exec property. If the FD is to be saved (first time)
>>> then this is followed by a 'struct cr_hdr_fd_data' with the FD state.
>>> Then will come the next FD and so on.
>>>
>>> This patch only handles basic FDs - regular files, directories and also
>>> symbolic links.
>>
>> [...]
>
> [...]
>
>>
>>> @@ -114,4 +125,24 @@ struct cr_hdr_vma {
>>>
>>>  } __attribute__ ((aligned (8)));
>>>
>>> +struct cr_hdr_files {
>>> +	__u32 tag;	/* sharing identifier */
>>> +	__u32 nfds;
>>> +} __attribute__ ((aligned (8)));
>>> +
>>> +struct cr_hdr_fd_ent {
>>> +	__u32 tag;
>>> +	__u16 fd;
>>> +	__u16 close_on_exec;
>>> +} __attribute__ ((aligned (8)));
>>> +
>>> +struct cr_hdr_fd_data {
>>> +	__u16 how;
>>> +	__u16 f_mode;
>>> +	__u32 f_flags;
>>> +	__u32 f_uid, f_gid;
>>
>> We are not at a 64bits boundary here. Should add one __32 padding or reo=
rder the
>> fields.
>
> Actually this is ok - note there are two fields on fourth row. I'll
> change to one field per row so it's easily seen.

Have to revise my eyes, really ;) Sorry for the noise!

Louis

--=20
Dr Louis Rilling			Kerlabs - IRISA
Skype: louis.rilling			Campus Universitaire de Beaulieu
Phone: (+33|0) 2 99 84 71 52		Avenue du General Leclerc
Fax: (+33|0) 2 99 84 71 71		35042 Rennes CEDEX - France
http://www.kerlabs.com/

--=_bohort-6405-1219660109-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIsonNVKcRuvQ9Q1QRAgtIAJoCcCBbIuHwlVTMq50YVjsunQMcIQCgqNsu
ik5ppNL6mHmGnmAPo59DobM=
=IM/E
-----END PGP SIGNATURE-----

--=_bohort-6405-1219660109-0001-2--
