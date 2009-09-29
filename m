Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbZI2RZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbZI2RZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZI2RZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:25:21 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:53672 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbZI2RZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:25:20 -0400
Subject: Re: Paravirtualization on VMware's Platform [VMI].
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Chris Wright <chrisw@sous-sol.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Gerd Hoffmann <kraxel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090929090130.GD3958@sequoia.sous-sol.org>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
	 <20090919224430.GB9567@kroah.com>
	 <1253419185.3253.21.camel@ank32.eng.vmware.com>
	 <20090920074247.GA5733@elte.hu>
	 <1253647845.10565.20.camel@ank32.eng.vmware.com>
	 <4AB9CE66.1030504@redhat.com>
	 <1254185107.13456.32.camel@ank32.eng.vmware.com>
	 <4AC17018.4040600@zytor.com>
	 <1254193238.13456.48.camel@ank32.eng.vmware.com>
	 <20090929090130.GD3958@sequoia.sous-sol.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 29 Sep 2009 10:25:24 -0700
Message-Id: <1254245124.7803.34.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-09-29 at 02:01 -0700, Chris Wright wrote:
> * Alok Kataria (akataria@vmware.com) wrote:
> > 
> > On Mon, 2009-09-28 at 19:25 -0700, H. Peter Anvin wrote:
> > > On 09/28/2009 05:45 PM, Alok Kataria wrote:
> > > > +	bool "VMI Guest support [will be deprecated soon]"
> > > > +	default n
> > > 
> > > This is incorrect use of the word "deprecated"... it's *already*
> > > deprecated (a word which pretty much means the opposite of "recommended".)
> > > 
> > > As far as "default n" is concerned... this is usually not necessary; "n"
> > > is the default unless anything else is specified.
> > 
> > How about this ?  Thanks.
> 
> Looks good to me (missing Signed-off-by).  I think it's also useful
> to generate some runtime noise saying it's a deprecated option.
> 
> Even something as simple as:
> 
> -	pv_info.name = "vmi"
> +	pv_info.name = "vmi [deprecated]";
> 

Yep, I was thinking of adding KERN_WARN's in vmi_init, though I like
your suggestion better. Also added SOB line. Thanks.

--

Mark VMI for removal in feature-removal-schedule.txt.

From: Alok N Kataria <akataria@vmware.com>

Add text in feature-removal.txt and also modify Kconfig to disable
vmi by default.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
---

 Documentation/feature-removal-schedule.txt |   30 ++++++++++++++++++++++++++++
 arch/x86/Kconfig                           |   12 ++++++++---
 arch/x86/kernel/vmi_32.c                   |    2 +-
 3 files changed, 40 insertions(+), 4 deletions(-)


diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 89a47b5..04e6c81 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -451,3 +451,33 @@ Why:	OSS sound_core grabs all legacy minors (0-255) of SOUND_MAJOR
 	will also allow making ALSA OSS emulation independent of
 	sound_core.  The dependency will be broken then too.
 Who:	Tejun Heo <tj@kernel.org>
+
+----------------------------
+
+What:	Support for VMware's guest paravirtuliazation technique [VMI] will be
+	dropped.
+When:	2.6.37 or earlier.
+Why:	With the recent innovations in CPU hardware acceleration technologies
+	from Intel and AMD, VMware ran a few experiments to compare these
+	techniques to guest paravirtualization technique on VMware's platform.
+	These hardware assisted virtualization techniques have outperformed the
+	performance benefits provided by VMI in most of the workloads. VMware
+	expects that these hardware features will be ubiquitous in a couple of
+	years, as a result, VMware has started a phased retirement of this
+	feature from the hypervisor. We will be removing this feature from the
+	Kernel too. Right now we are targeting 2.6.37 but can retire earlier if
+	technical reasons (read opportunity to remove major chunk of pvops)
+	arise.
+
+	Please note that VMI has always been an optimization and non-VMI kernels
+	still work fine on VMware's platform.
+	Latest versions of VMware's product which support VMI are,
+	Workstation 7.0 and VSphere 4.0 on ESX side, future maintainence
+	releases for these products will continue supporting VMI.
+
+	For more details about VMI retirement take a look at this,
+	http://blogs.vmware.com/guestosguide/2009/09/vmi-retirement.html
+
+Who:	Alok N Kataria <akataria@vmware.com>
+
+----------------------------
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f777aaf..44c1660 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -496,14 +496,20 @@ if PARAVIRT_GUEST
 source "arch/x86/xen/Kconfig"
 
 config VMI
-	bool "VMI Guest support"
-	select PARAVIRT
-	depends on X86_32
+	bool "VMI Guest support [deprecated]"
+	depends on X86_32 && PARAVIRT
 	---help---
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
 	  at the moment), by linking the kernel to a GPL-ed ROM module
 	  provided by the hypervisor.
+	  As of September 2009, VMware has started a phased retirement of this
+	  feature from VMware's products. Please see
+	  feature-removal-schedule.txt for details.
+	  If you are planning to enable this option, please note that you
+	  cannot live migrate a VMI enabled VM to a future VMware product,
+	  which doesn't support VMI. So if you expect your kernel to seamlessly
+	  migrate to newer VMware products, keep this disabled.
 
 config KVM_CLOCK
 	bool "KVM paravirtualized clock"
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 31e6f6c..d430e4c 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -648,7 +648,7 @@ static inline int __init activate_vmi(void)
 
 	pv_info.paravirt_enabled = 1;
 	pv_info.kernel_rpl = kernel_cs & SEGMENT_RPL_MASK;
-	pv_info.name = "vmi";
+	pv_info.name = "vmi [deprecated]";
 
 	pv_init_ops.patch = vmi_patch;
 


