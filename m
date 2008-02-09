Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbYBIO1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbYBIO1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 09:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYBIO1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 09:27:06 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:60054 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbYBIO1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 09:27:05 -0500
Message-ID: <47ADB836.9030404@web.de>
Date: Sat, 09 Feb 2008 15:27:02 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: jason.wessel@windriver.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] kgdb: core API and gdb protocol handler
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com> <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEB8F57BA8B93AE837EF2EFB4"
X-Provags-ID: V01U2FsdGVkX18Z+i4wYooY1KugX7JTgt0o2Pfz+g9mR3ucMLRs
	+9VQSaAJc9EqLIhRzR6fawMRvIPYpwWzWhIg0BBcjduRs0jIK6
	JJ5TxKOSE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEB8F57BA8B93AE837EF2EFB4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

jason.wessel@windriver.com wrote:
> --- /dev/null
> +++ b/include/asm-generic/kgdb.h
> @@ -0,0 +1,105 @@
> +/*
> + * include/asm-generic/kgdb.h
> + *
> + * This provides the assembly level information so that KGDB can provi=
de
> + * a GDB that has been patched with enough information to know to stop=

> + * trying to unwind the function.
> + *
> + * Author: Tom Rini <trini@kernel.crashing.org>
> + *
> + * 2005 (c) MontaVista Software, Inc.
> + * 2006 (c) Embedded Alley Solutions, Inc.
> + *
> + * This file is licensed under the terms of the GNU General Public Lic=
ense
> + * version 2. This program is licensed "as is" without any warranty of=
 any
> + * kind, whether express or implied.
> + */
> +
> +#ifndef __ASM_GENERIC_KGDB_H__
> +#define __ASM_GENERIC_KGDB_H__
> +
> +struct pt_regs;
> +
> +#ifdef CONFIG_X86

Hmm, I just realized that I didn't really looked at the arch interface
in details yet. Now it appears a bit inconsistent to me in its way to
tell "this arch supports that". Something in include/asm-generic that
starts with #ifdef CONFIG_X86 looks ugly, to begin with.

=2E..
> +#ifdef CONFIG_KGDB_ARCH_HAS_SHADOW_INFO

Then we have this KGDB_ARCH_HAS thing here, the second way to control
arch-dependent stuff.

=2E..
> --- /dev/null
> +++ b/include/linux/kgdb.h
=2E..
> +struct kgdb_arch {
> +	unsigned char		gdb_bpt_instr[BREAK_INSTR_SIZE];
> +	unsigned long		flags;
> +	unsigned		shadowth;
> +
> +	int	(*set_breakpoint)(unsigned long, char *);
> +	int	(*remove_breakpoint)(unsigned long, char *);
> +	int	(*set_hw_breakpoint)(unsigned long, int, enum kgdb_bptype);
> +	int	(*remove_hw_breakpoint)(unsigned long, int, enum kgdb_bptype);
> +	void	(*remove_all_hw_break)(void);
> +	void	(*correct_hw_break)(void);
> +};

And this is the third way. Can we consolidate this?

=2E..
> --- /dev/null
> +++ b/kernel/kgdb.c
=2E..
> +/*
> + * Convert the memory pointed to by mem into hex, placing result in bu=
f.
> + * Return a pointer to the last char put in buf (null). May return an =
error.
> + */
> +char *kgdb_mem2hex(char *mem, char *buf, int count)

As Linus remarked, still pointer-based return values while only the
error code is used by the callers (there are more of such cases in the
core).

=2E..
> --- a/kernel/softlockup.c
> +++ b/kernel/softlockup.c
=2E..
> @@ -52,7 +55,6 @@ static unsigned long get_timestamp(int this_cpu)
>  void touch_softlockup_watchdog(void)
>  {
>  	int this_cpu =3D raw_smp_processor_id();
> -

Probably some relic from older changes which should be killed.

Jan


--------------enigEB8F57BA8B93AE837EF2EFB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHrbg2niDOoMHTA+kRAhPQAJ9DuDm1kYU0cw0P4IIza//0x3IRbQCdFH6H
YX9hLONIEO4n5bb/DMhxuss=
=RM78
-----END PGP SIGNATURE-----

--------------enigEB8F57BA8B93AE837EF2EFB4--
