Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab0CCXLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:11:00 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:59336 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0CCXKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:10:51 -0500
Message-ID: <4B8EEC72.9090806@web.de>
Date: Thu, 04 Mar 2010 00:10:42 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/18][RFC] Nested Paging support for Nested SVM (aka NPT-Virtualization)
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD700E35600E9E6784CEEB847"
X-Provags-ID: V01U2FsdGVkX1+W8/qjlTYTgKHkX8oZx75zj9058sTGK+aGL1NF
	W/znYlhoVcl5DtvC0wtdYs5IpJynBxYR3c9ORZeAsE63zOP9gd
	zmIjIRZgs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD700E35600E9E6784CEEB847
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Joerg Roedel wrote:
> Hi,
>=20
> here are the patches that implement nested paging support for nested
> svm. They are somewhat intrusive to the soft-mmu so I post them as RFC
> in the first round to get feedback about the general direction of the
> changes.  Nevertheless I am proud to report that with these patches the=

> famous kernel-compile benchmark runs only 4% slower in the l2 guest as
> in the l1 guest when l2 is single-processor. With SMP guests the

Wow!

Jan

> situation is very different. The more vcpus the guest has the more is
> the performance drop from l1 to l2.=20
> Anyway, this post is to get feedback about the overall concept of these=

> patches.  Please review and give feedback :-)
>=20
> Thanks,
>=20
> 	Joerg
>=20
> Diffstat:
>=20
>  arch/x86/include/asm/kvm_host.h |   21 ++++++
>  arch/x86/kvm/mmu.c              |  152 ++++++++++++++++++++++++++++++-=
--------
>  arch/x86/kvm/mmu.h              |    2 +
>  arch/x86/kvm/paging_tmpl.h      |   81 ++++++++++++++++++---
>  arch/x86/kvm/svm.c              |  126 +++++++++++++++++++++++++++----=
-
>  arch/x86/kvm/vmx.c              |    9 +++
>  arch/x86/kvm/x86.c              |   19 +++++-
>  include/linux/kvm.h             |    1 +
>  include/linux/kvm_host.h        |    5 ++
>  9 files changed, 354 insertions(+), 62 deletions(-)
>=20
> Shortlog:
>=20
> Joerg Roedel (18):
>       KVM: MMU: Check for root_level instead of long mode
>       KVM: MMU: Make tdp_enabled a mmu-context parameter
>       KVM: MMU: Make set_cr3 a function pointer in kvm_mmu
>       KVM: X86: Introduce a tdp_set_cr3 function
>       KVM: MMU: Introduce get_cr3 function pointer
>       KVM: MMU: Introduce inject_page_fault function pointer
>       KVM: SVM: Implement MMU helper functions for Nested Nested Paging=

>       KVM: MMU: Change init_kvm_softmmu to take a context as parameter
>       KVM: MMU: Let is_rsvd_bits_set take mmu context instead of vcpu
>       KVM: MMU: Introduce generic walk_addr function
>       KVM: MMU: Add infrastructure for two-level page walker
>       KVM: MMU: Implement nested gva_to_gpa functions
>       KVM: MMU: Introduce Nested MMU context
>       KVM: SVM: Initialize Nested Nested MMU context on VMRUN
>       KVM: MMU: Propagate the right fault back to the guest after gva_t=
o_gpa
>       KVM: X86: Add callback to let modules decide over some supported =
cpuid bits
>       KVM: SVM: Report Nested Paging support to userspace
>       KVM: X86: Add KVM_CAP_SVM_CPUID_FIXED
>=20
>=20


--------------enigD700E35600E9E6784CEEB847
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkuO7HIACgkQitSsb3rl5xTSCgCgwOwe9+EzmLYNI1wB3I5K7Mih
174AnRIc9bTidc4efQnAWi2nTTV65np/
=Y6Kg
-----END PGP SIGNATURE-----

--------------enigD700E35600E9E6784CEEB847--
