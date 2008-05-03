Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbYECIkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbYECIkf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 04:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbYECIk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 04:40:27 -0400
Received: from rk.rkuhn.info ([88.198.164.84]:39475 "EHLO mailhost.rkuhn.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbYECIkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 04:40:25 -0400
From: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
To: SL Baur <steve@xemacs.org>
In-Reply-To: <ed10ee420805022355j4e783fa1qce38d37ab8c4841f@mail.gmail.com>
Subject: Re: cross-compiling on OS X, make menuconfig fails
References: <481529B6.6030802@freescale.com> <20080428015151.GW20457@bakeyournoodle.com> <481739BF.8010305@freescale.com> <20080429164535.GB18018@uranus.ravnborg.org> <20080429172057.GN5882@ZenIV.linux.org.uk> <20080429180601.GA19652@uranus.ravnborg.org> <ed10ee420805022355j4e783fa1qce38d37ab8c4841f@mail.gmail.com>
Message-Id: <5460B94D-5B3B-4174-9432-C45521A9C247@e18.physik.tu-muenchen.de>
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-1--431419538"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sat, 3 May 2008 10:40:14 +0200
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Al Viro" <viro@zeniv.linux.org.uk>,
       "Timur Tabi" <timur@freescale.com>,
       "Tony Breeds" <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org
X-Pgp-Agent: GPGMail d51 (Leopard)
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-1--431419538
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

Hi Steve!

On 3 May 2008, at 08:55, SL Baur wrote:

> On 4/29/08, Sam Ravnborg <sam@ravnborg.org> wrote:
>>>
>>> Good grief, folks...
>>
>> Thanks Al.
>> I've queued up the following patch.
>>
>>        Sam
>>
>> commit c99cc32e0d92f5fdbdd39a7f42cfff869062fff5
>> Author: Sam Ravnborg <sam@uranus.ravnborg.org>
>> Date:   Tue Apr 29 20:02:44 2008 +0200
>>
>>    kconfig: made check-lxdialog more portable
>>
>>    OS-X shell did not like 'echo -e' so implement
>>    suggestion from Al Viro to use a more portable construct.
>>
>>    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
>>    Cc: Al Viro <viro@ZenIV.linux.org.uk>
>>
>> diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/ 
>> kconfig/lxdialog/check-lxdialog.sh
>> index 62e1e02..5552154 100644
>> --- a/scripts/kconfig/lxdialog/check-lxdialog.sh
>> +++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
>> @@ -36,8 +36,10 @@ trap "rm -f $tmp" 0 1 2 3 15
>>
>>  # Check if we can link to ncurses
>>  check() {
>> -       echo -e " #include CURSES_LOC \n main() {}" |
>> -           $cc -xc - -o $tmp 2> /dev/null
>> +        $cc -xc - -o $tmp 2>/dev/null <<'EOF'
>>
>> +#include CURSES_LOC
>> +main() {}
>> +EOF
>>
>>        if [ $? != 0 ]; then
>>            echo " *** Unable to find the ncurses libraries or  
>> the"       1>&2
>>            echo " *** required header  
>> files."                            1>&2
>
> This looks O.K.  As a note, whatever behavior is being described here
> is system dependent, because on my installation of that other OS,  
> `echo -e'
> works fine whether it is invoked as /bin/bash or /bin/sh which  
> appears to be
> a strict copy of /bin/bash.
>
> $ uname -v
> Darwin Kernel Version 8.11.1: Wed Oct 10 18:23:28 PDT 2007;
> root:xnu792.25.20~1/RELEASE_I386
>
Yes, they changed that between Tiger and Leopard, where I have

---
$ uname -v
Darwin Kernel Version 9.2.2: Tue Mar  4 21:17:34 PST 2008;  
root:xnu-1228.4.31~1/RELEASE_I386
$ /bin/bash -c 'echo -e "buh\n"'
buh

$ /bin/sh -c 'echo -e "buh\n"'
-e buh

$ /bin/echo -e "buh\n"
-e buh\n
---

The second one is POSIX+XSI, the third one plain POSIX. The first one  
is what people are used to ;-)

Ciao,
                     Roland

--
Any society that would give up a little liberty to gain a little
security will deserve neither and lose both.  - Benjamin Franklin
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GS/CS/M/MU d-(++) s:+ a-> C+++ UL++++ P+++ L+++ E(+) W+ !N K- w--- M+ ! 
V Y+
PGP++ t+(++) 5 R+ tv-- b+ DI++ e++++ h---- y+++
------END GEEK CODE BLOCK------




--Apple-Mail-1--431419538
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (Darwin)

iEYEARECAAYFAkgcJO4ACgkQI4MWO8QIRP0cWgCeP5PYuy7G/M2pX82TLrb1MOUK
VMwAn0bHipCAEy//XtCeB0Fe9oXmmCal
=jsf4
-----END PGP SIGNATURE-----

--Apple-Mail-1--431419538--
