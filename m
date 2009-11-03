Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZKCUjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZKCUjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZKCUjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:39:17 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:40395 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZKCUjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:39:17 -0500
Message-ID: <4AF094F4.9060108@web.de>
Date: Tue, 03 Nov 2009 21:39:16 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
 on top of perf events
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-5-git-send-email-fweisbec@gmail.com> <4AF08B7C.8040903@web.de> <20091103201503.GA4962@nowhere> <4AF090EC.5010105@web.de> <20091103202923.GB4962@nowhere>
In-Reply-To: <20091103202923.GB4962@nowhere>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2FD70683CE561310D2D217A1"
X-Provags-ID: V01U2FsdGVkX1+HOoTdCn0+XY8e4a0G8oH/hgz8JMWz6FNDuxxO
	h9SZEzXPFB8LA+3jLbXmaOX3sEKy6vvOQGs2hUERV/57xyCqwx
	4RKcF0Fi8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2FD70683CE561310D2D217A1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Frederic Weisbecker wrote:
> On Tue, Nov 03, 2009 at 09:22:04PM +0100, Jan Kiszka wrote:
>>> Thinking about it, this check should cover every cases:
>>>
>>> if (vcpu->arch.switch_db_regs || __get_cpu_var(dr7) & DR_GLOBAL_ENABL=
E_MASK)
>>>
>>> If we have __get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK, it means there=
 is an
>>> active breakpoint and then we should restore the current state.
>>>
>> And what about (__get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK) only? Woul=
d
>> you be able to live with unsync'ed hardware and software states?
>>
>> Jan
>>
>=20
>=20
> But if the guest has breakpoints activated, the host will inherit
> them, which is really not something we want, assuming vcpu->arch.switch=
_db_regs
> already protects us about that.
>=20

Nope, vmx&svm will clear dr7 on vmexit for us. Really, switch_db_regs
should not be needed if we can leave the debug registers clobbered but
disabled behind.

Jan


--------------enig2FD70683CE561310D2D217A1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEUEARECAAYFAkrwlPcACgkQitSsb3rl5xTmpQCY9Lx1iZL15kv3owUUo5v+Cs7l
HwCdEP5ZnuDzhKNhEeQUH4zFJzTWOBs=
=6ep1
-----END PGP SIGNATURE-----

--------------enig2FD70683CE561310D2D217A1--
