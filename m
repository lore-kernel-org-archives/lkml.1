Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbXHMQHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbXHMQHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947024AbXHMOlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:41:32 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34168 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946683AbXHMOl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:41:27 -0400
Message-ID: <46C06D99.2030106@bull.net>
Date: Mon, 13 Aug 2007 16:41:29 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       kvm-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
References: <46BC8B39.6050202@bull.net>	<200708131605.40479.borntraeger@de.ibm.com> <46C0693A.1080900@bull.net> <46C06AFE.2050702@qumranet.com>
In-Reply-To: <46C06AFE.2050702@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/08/2007 16:46:31,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/08/2007 16:46:32,
	Serialize complete at 13/08/2007 16:46:32
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDDA632D6E8F506DAF2ED56AF"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDDA632D6E8F506DAF2ED56AF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Laurent Vivier wrote:
>> Christian Borntraeger wrote:
>> =20
>>> Am Freitag, 10. August 2007 schrieb Laurent Vivier:
>>>   =20
>>>> The aim of these two patches is to measure the CPU time used by a
>>>> virtual
>>>> machine. All comments are welcome... I'm not sure it's the good way
>>>> to do      =20
>>> that.
>>>
>>> I did something similar for or s390guest prototype, that Carsten
>>> posted in May.  I decided to account guest time to the user process
>>> instead of adding a new field to avoid hazzle with old top. As you
>>> can read in the patch comment, I personally prefer a new field if we
>>> can get one.
>>>
>>> My implementation uses a similar mechanism like hard and softirq. So
>>> I have an sie_enter an sie_exit and a task_is_in_sie function - like
>>> irq_enter and irq_exit. The main difference is based on the fact,
>>> that s390 has precise accouting for irq, steal, user and system time,=

>>> and therefore my patch is based on architecture specifc code using
>>> CONFIG_VIRT_CPU_ACCOUNT.
>>> In general my patch has the same idea as your patch, so I am going to=

>>> review your patch and see if it would fit for s390.
>>>
>>> For reference this is the (never posted) old patch for our
>>> virtualisation prototype. It wont work with kvm but it gives you the
>>> idea what we had in mind on s390.
>>>
>>>    =20
>>
>> thank you for your comment.
>>
>> As virtualization becomes very popular, perhaps we should implement
>> something
>> which could be used by all linux supported architectures ?
>> (yes, I know it's non-sense for archs like m68k...)
>> But my [PATCH 1/2] can be a good start (adding "guest" in cpustat)
>> As guest accounting is hw dependent, I think we should add a hook in t=
he
>> accounting functions.
>>  =20
>=20
> Isn't PF_VM exactly such a hook?  All the hypervisor needs to do is to
> set/unset it correctly?

In fact, no.

PF_VM is used to know we have entered a virtual CPU (the hypervisor set i=
t, the
scheduler unset it on accounting)

I mean a hook in account_system_time() to call a function arch-dependent =
to
compute the guest time (and modify the system/user time accordingly) if n=
eeded.

If fact what I find annoying in my patch is it adds to guest time and use=
r time
some system time. Perhaps you could have a look to the second patch I sen=
t.

Regards,
Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enigDDA632D6E8F506DAF2ED56AF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGwG2c9Kffa9pFVzwRAhszAKCRtjWfiq6ZYeIel1BQrkaH2IgATACgmdIK
7iMzG7gxu19UXJc7jrn/4mg=
=Qs8g
-----END PGP SIGNATURE-----

--------------enigDDA632D6E8F506DAF2ED56AF--
