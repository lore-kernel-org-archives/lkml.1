Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbZDTBUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbZDTBUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZDTBTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:19:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:48798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZDTBTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:19:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,214,1239001200"; 
   d="asc'?scan'208";a="507778355"
Subject: Re: [PATCH -v2] Add MCE support to KVM
From: Huang Ying <ying.huang@intel.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <49E9F7BE.4090904@codemonkey.ws>
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com>
	 <49E9F7BE.4090904@codemonkey.ws>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Uc93KGTo9Au3JflQGU7I"
Date: Mon, 20 Apr 2009 09:19:45 +0800
Message-Id: <1240190385.6842.45.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Uc93KGTo9Au3JflQGU7I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 23:54 +0800, Anthony Liguori wrote:
> Huang Ying wrote:
> > The related MSRs are emulated. MCE capability is exported via
> > extension KVM_CAP_MCE and ioctl KVM_X86_GET_MCE_CAP_SUPPORTED. A new
> > vcpu ioctl command KVM_X86_SETUP_MCE is used to setup MCE emulation
> > such as the mcg_cap. MCE is injected via vcpu ioctl command
> > KVM_X86_SET_MCE. Extended machine-check state (MCG_EXT_P) and CMCI are
> > not simulated.
> >  =20
>=20
> Maybe I'm missing something, but couldn't this be implemented entirely=20
> within userspace?  There's nothing VT/SVM specific about this.  If the=20
> issue is setting these MSRs from userspace via KVM_SET_MSRS isn't=20
> enough, perhaps we should add userspace MSR handling.
>=20
> Also, if you implement the MSR logic in userspace, it's pretty simple to=20
> make it work in the non-TCG case which will be a requirement for=20
> upstream merging.

There is more logic than just KVM_SET_MSRS, such as BANK reporting
disabling, overwriting rules, triple fault for UC MCE during MCIP.
Although these logic can be implemented in user space, I think put them
in kernel space is easy to be understood. And the code is pretty short.

Best Regards,
Huang Ying


--=-Uc93KGTo9Au3JflQGU7I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknrzaYACgkQKhFGF+eHlpgB9wCfcxXH4LQpHuTXak6QXKHGmOav
9pUAoJbCp7c4vbPwOTI8ktZ9MrYXQxm9
=XD5N
-----END PGP SIGNATURE-----

--=-Uc93KGTo9Au3JflQGU7I--

