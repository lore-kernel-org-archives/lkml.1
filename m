Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYLaLF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYLaLF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbYLaLFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:05:19 -0500
Received: from ozlabs.org ([203.10.76.45]:34368 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbYLaLFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:05:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [-tip tree] compile error in arch/ia64/kernel/acpi.c
Date: Wed, 31 Dec 2008 21:35:08 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luck, Tony" <tony.luck@intel.com>
References: <495B3857.90802@cn.fujitsu.com>
In-Reply-To: <495B3857.90802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812312135.09293.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 December 2008 19:46:07 Li Zefan wrote:
> arch/ia64/kernel/acpi.c:205: error: conflicting types for 'total_cpus'
> include/linux/smp.h:25: error: previous declaration of 'total_cpus' was here
> 
> due to [PATCH 3/3] cpumask: add sysfs displays for configured and disabled cpu maps
> (http://lkml.org/lkml/2008/12/19/25)

Hmm, I don't know how this escaped linux-next.  But the fix is simple:

Subject: Remove IA64 definition of total_cpus now it's in core code

Impact: fix IA64 compile

Fortunately, they have exactly the same semantics.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -202,7 +202,6 @@ char *__init __acpi_map_table(unsigned l
                             Boot-time Table Parsing
    -------------------------------------------------------------------------- */
 
-static int total_cpus __initdata;
 static int available_cpus __initdata;
 struct acpi_table_madt *acpi_madt __initdata;
 static u8 has_8259;
