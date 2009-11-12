Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbZKLMPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbZKLMPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 07:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZKLMPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 07:15:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbZKLMPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 07:15:43 -0500
From: Thomas Renninger <trenn@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the cpufreq tree with the acpi tree
Date: Thu, 12 Nov 2009 06:15:37 -0600
User-Agent: KMail/1.9.10
Cc: Dave Jones <davej@redhat.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
       Len Brown <lenb@kernel.org>
References: <20091112134524.d9854379.sfr@canb.auug.org.au>
In-Reply-To: <20091112134524.d9854379.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911120615.38067.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 November 2009 08:45:24 pm Stephen Rothwell wrote:
> Hi Dave,
>
> Today's linux-next merge of the cpufreq tree got a conflict in
> include/acpi/processor.h between commit
> d81c45e1c9369855901420f79114852eba2ea16a ("ACPI: Notify the _PPC
> evaluation status to the platform") from the acpi tree and commit
> b02d803d0fa3a395ba32bc5e5e3e7a3385ca7237 ("[CPUFREQ] Introduce bios_limit
> per cpu cpufreq sysfs interface") from the cpufreq tree.
First, thanks everybody for picking this up.

> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
>
> By the way, Dave, Thomas, shouldn't the second version of
> acpi_processor_get_bios_limit() in include/acpi/processor.h introduced by
> the above cpufreq tree patch be "static inline"?
Yes, good catch.
Shall I send an on top fix somewhere?

   Thomas

@@ -295,6 +295,7 @@ static inline void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx
 void acpi_processor_ppc_init(void);
 void acpi_processor_ppc_exit(void);
 int acpi_processor_ppc_has_changed(struct acpi_processor *pr);
+extern int acpi_processor_get_bios_limit(int cpu, unsigned int *limit);
 #else
 static inline void acpi_processor_ppc_init(void)
 {
@@ -316,6 +317,11 @@ static inline int acpi_processor_ppc_has_changed(struct acpi_processor *pr)
 	}
 	return 0;
 }
+int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
+{
+	return -ENODEV;
+}
+
 #endif				/* CONFIG_CPU_FREQ */
 
