Return-Path: <linux-kernel-owner+w=401wt.eu-S1762852AbZJOQPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762852AbZJOQPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761456AbZJOQPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:15:23 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:2077 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZJOQPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=wFVEUYv+IC/ebLSE81U60A/qokHH0QgF5fuTyWYASS3Oe9is/EHwtcd82gRGikzLHY
         emkX/hsjuZfRAOYYUrBWzjbSNCn9pO7gGvHtbST6sec1HrggHYX/5mBET02M2hFay5Nc
         BplXzMI5XtFWTuXhQ+w2cUIIyICPWC9WJ55os=
Message-ID: <4AD74A2A.3090506@gmail.com>
Date: Thu, 15 Oct 2009 12:13:30 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Daniel Walker <dwalker@fifo99.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Tips for module_init() dependencies
References: <4AD71D12.9060203@gmail.com>	<1255621559.22917.35.camel@desktop>	<4AD7469B.9070907@gmail.com> <20091015090645.140e04f4.rdunlap@xenotime.net>
In-Reply-To: <20091015090645.140e04f4.rdunlap@xenotime.net>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig81CB45EFCF9584A89C808588"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig81CB45EFCF9584A89C808588
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Randy Dunlap wrote:
> On Thu, 15 Oct 2009 11:58:19 -0400 Gregory Haskins wrote:
>=20
>> Daniel Walker wrote:
>>> On Thu, 2009-10-15 at 09:01 -0400, Gregory Haskins wrote:
>>>
>>>> may break, because the kernel seems to have no concept of
>>>> interdependency between foo_init() and bar_init(), and therefore
>>>> bar_init() may call foo() before foo_init() has executed.
>>>>
>>>> There are various ways to solve this problem, such as deferring call=
ing
>>>> foo() with a workqueue or something, but I was wondering if there wa=
s a
>>>> better/standard way to do this that I am missing?
>>>>
>>>> The problem I am having specifically is that I am trying to call
>>>> configfs_register_subsystem() in a module_init(), but this breaks wh=
en
>>>> built into the kernel based on sheer bad luck that configfs gets
>>>> initialized after me.  To date I have worked around this by forcing =
my
>>>> code to only support built-in, and using late_initcall() instead or
>>>> module_init.  This works, but it only means I am putting the problem=
 off
>>>> (code that depends on *me* has to use similar tricks, etc.
>>> You can't modify the build order so your module get "builtin" after
>>> configfs?
>>>
>> Hi Daniel,
>>
>> Possibly.
>>
>> A) Any suggestions on how? Can I express this in Kconfig or something
>> (i.e. "depends on FOO").  I currently have "select FOO" in the BAR
>> object, but this doesn't seem to be sufficient to describe the relatio=
nship.
>=20
> Not in Kconfig, only in Makefile(s).
> and please put #comments in them explaining the ordering requirements/n=
eeds.

Hi Randy,

Something like this?

----------

# cat drivers/bar/Makefile

bar.o: foo.o
obj-$CONFIG_BAR +=3D bar.o

----------

?

Kind Regards,
-Greg


--------------enig81CB45EFCF9584A89C808588
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrXSioACgkQP5K2CMvXmqGXugCfTI2nKU0uSayo/T4aJPlXakjY
MlYAn0ROIJUqCj6sGKkYDAXDGi9tk5gt
=1fK8
-----END PGP SIGNATURE-----

--------------enig81CB45EFCF9584A89C808588--
