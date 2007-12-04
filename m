Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbXLDQpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbXLDQpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXLDQpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:45:32 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:51306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXLDQpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:45:31 -0500
Subject: Re: [PATCH v2] Fix hardware IRQ time accounting problem.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Paul Mackerras <paulus@samba.org>, LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Frederik Himpe <fhimpe@telenet.be>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <20071204055144.GR24243@bakeyournoodle.com>
References: <20071204055144.GR24243@bakeyournoodle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8MBi15lijnFwBt/EMClK"
Date: Tue, 04 Dec 2007 17:44:01 +0100
Message-Id: <1196786641.10274.20.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8MBi15lijnFwBt/EMClK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-12-04 at 16:51 +1100, Tony Breeds wrote:
> The commit fa13a5a1f25f671d084d8884be96fc48d9b68275 (sched: restore
> deterministic CPU accounting on powerpc), unconditionally calls
> update_process_tick() in system context.  In the deterministic accounting=
 case
> this is the correct thing to do.  However, in the non-deterministic accou=
nting
> case we need to not do this, and results in the time accounted as hardwar=
e irq
> time being artificially elevated.

Cool, I wouldn't have stood a chance of tracking this down :) Thanks,
I'll apply it to my testing tree later today.

> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> ---
> The problem was seen and reported by Johannes Berg  and Frederik Himpe.
> Paul, I think this is good for 2.6.24.
>=20
> Changes since v1:
>  - I noticed that the #define was explictly using "current" rather than
>    the task passed in.  Using tsk is the right thing to do.
>  - The whiteapce changes dirty-up the patch and are un-needed with the
>    change above.
>=20
>  arch/powerpc/kernel/process.c |    2 +-
>  include/asm-powerpc/time.h    |    8 ++------
>  2 files changed, 3 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.=
c
> index 41e13f4..b9d8837 100644
> --- a/arch/powerpc/kernel/process.c
> +++ b/arch/powerpc/kernel/process.c
> @@ -350,7 +350,7 @@ struct task_struct *__switch_to(struct task_struct *p=
rev,
>  	local_irq_save(flags);
> =20
>  	account_system_vtime(current);
> -	account_process_tick(current, 0);
> +	account_process_vtime(current);
>  	calculate_steal_time();
> =20
>  	last =3D _switch(old_thread, new_thread);
> diff --git a/include/asm-powerpc/time.h b/include/asm-powerpc/time.h
> index 780f826..a7281e0 100644
> --- a/include/asm-powerpc/time.h
> +++ b/include/asm-powerpc/time.h
> @@ -237,18 +237,14 @@ struct cpu_usage {
> =20
>  DECLARE_PER_CPU(struct cpu_usage, cpu_usage_array);
> =20
> -#ifdef CONFIG_VIRT_CPU_ACCOUNTING
> -extern void account_process_vtime(struct task_struct *tsk);
> -#else
> -#define account_process_vtime(tsk)		do { } while (0)
> -#endif
> -
>  #if defined(CONFIG_VIRT_CPU_ACCOUNTING)
>  extern void calculate_steal_time(void);
>  extern void snapshot_timebases(void);
> +#define account_process_vtime(tsk)		account_process_tick(tsk, 0);
>  #else
>  #define calculate_steal_time()			do { } while (0)
>  #define snapshot_timebases()			do { } while (0)
> +#define account_process_vtime(tsk)		do { } while (0)
>  #endif
> =20
>  extern void secondary_cpu_time_init(void);

--=-8MBi15lijnFwBt/EMClK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1WDz6Vg1VMiehFYAQL+aA/8CiyAhKY2GYXc00a6+nxpZkFP6vtmP93u
S+3W4cG40mt1l++preI1GCOL6Hq2rF9uOrQ9Am9Gn4Krkre9GORwpqj2oxC5KfR1
hdNd17yhnh/EITol2qZOD6P6sy2GfDsRzN0dbxQsrAWXO0kOHtwiO+V3iEq/8usO
SUlxVOekpk39Gp/sVb2GwLxg4LVvRHWLhOvvEPdsmfAtPh09IuEv5V2Cruje0h9w
xRZfnIF1Jq1tULEWjM2W4WUK8nDNJ93IFRlyhZwyq7iwyvHmItKhxB+DpuVU9EUK
2mQRoIsGcb+ePTVCIEuIJilswigAMvDmtFpsdyQXTjxteVvt7nBLLlHKWzed49gv
JMiQErTbCFrHMGAHjhMFUpJ322NDfh1k1ZtMnnvxGWwVelf2XE7QXesHl2KJDD8n
1xBZOaxLOWy9xQQ+Lc3TFAMPBbZqkRlMhaUC61bEUPnJVe95PsXXSxz1EpXnjh4P
IMAFSxFM75dra72WaaRf6IhOhSqn5cVPEvXR0HNZvYW0RzHTCGW68jfWv1FQc9Nd
VAH4JFapwKXuvJNTh/T7vpqHBlppmOFIWMK24CBIjUCWHiZLI5mYucOYqhXBLq0n
J3VRKMHP0Z45SynuPpxv9PqA6iSuMRZzBz7X12EPCN7h3vZLtrpQHtYEdlToyMSM
2/q6VpqdMeE=
=DeGy
-----END PGP SIGNATURE-----

--=-8MBi15lijnFwBt/EMClK--

