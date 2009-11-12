Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbZKLCpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbZKLCpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759997AbZKLCpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:45:22 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50266 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759961AbZKLCpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:45:21 -0500
Date: Thu, 12 Nov 2009 13:45:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Zhao Yakui <yakui.zhao@intel.com>,
       Len Brown <lenb@kernel.org>
Subject: linux-next: manual merge of the cpufreq tree with the acpi tree
Message-Id: <20091112134524.d9854379.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the cpufreq tree got a conflict in
include/acpi/processor.h between commit
d81c45e1c9369855901420f79114852eba2ea16a ("ACPI: Notify the _PPC
evaluation status to the platform") from the acpi tree and commit
b02d803d0fa3a395ba32bc5e5e3e7a3385ca7237 ("[CPUFREQ] Introduce bios_limit
per cpu cpufreq sysfs interface") from the cpufreq tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

By the way, Dave, Thomas, shouldn't the second version of
acpi_processor_get_bios_limit() in include/acpi/processor.h introduced by
the above cpufreq tree patch be "static inline"?
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/acpi/processor.h
index a920237,e7454b3..0000000
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@@ -294,7 -294,8 +294,8 @@@ static inline void acpi_processor_ffh_c
  #ifdef CONFIG_CPU_FREQ
  void acpi_processor_ppc_init(void);
  void acpi_processor_ppc_exit(void);
 -int acpi_processor_ppc_has_changed(struct acpi_processor *pr);
 +int acpi_processor_ppc_has_changed(struct acpi_processor *pr, int event_flag);
+ extern int acpi_processor_get_bios_limit(int cpu, unsigned int *limit);
  #else
  static inline void acpi_processor_ppc_init(void)
  {
