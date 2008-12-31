Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYLaPUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYLaPUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 10:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYLaPU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 10:20:26 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:48197 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbYLaPUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 10:20:25 -0500
Date: Wed, 31 Dec 2008 20:45:13 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [-tip tree] compile error in arch/ia64/kernel/acpi.c
Message-ID: <20081231151513.GB4268@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <495B3857.90802@cn.fujitsu.com> <200812312135.09293.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200812312135.09293.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell <rusty@rustcorp.com.au> [2008-12-31 21:35:08]:

> On Wednesday 31 December 2008 19:46:07 Li Zefan wrote:
> > arch/ia64/kernel/acpi.c:205: error: conflicting types for 'total_cpus'
> > include/linux/smp.h:25: error: previous declaration of 'total_cpus' was here
> > 
> > due to [PATCH 3/3] cpumask: add sysfs displays for configured and disabled cpu maps
> > (http://lkml.org/lkml/2008/12/19/25)
> 
> Hmm, I don't know how this escaped linux-next.  But the fix is simple:
> 
Hi Rusty,

	This was caught in today's linux-next :)


> Subject: Remove IA64 definition of total_cpus now it's in core code
> 
> Impact: fix IA64 compile
> 
> Fortunately, they have exactly the same semantics.
> 
  Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
> --- a/arch/ia64/kernel/acpi.c
> +++ b/arch/ia64/kernel/acpi.c
> @@ -202,7 +202,6 @@ char *__init __acpi_map_table(unsigned l
>                              Boot-time Table Parsing
>     -------------------------------------------------------------------------- */
> 
> -static int total_cpus __initdata;
>  static int available_cpus __initdata;
>  struct acpi_table_madt *acpi_madt __initdata;
>  static u8 has_8259;

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
