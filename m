Return-Path: <linux-kernel-owner+w=401wt.eu-S933485AbZD3Rh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485AbZD3Rh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764564AbZD3RIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:25 -0400
Received: from kroah.org ([198.145.64.141]:56765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764632AbZD3RIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:47 2009
Message-Id: <20090430165747.562438312@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, avi@redhat.com,
       Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [patch 62/88] KVM: Fix cpuid leaf 0xb loop termination
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-cpuid-leaf-0xb-loop-termination.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nitin A Kamble <nitin.a.kamble@intel.com>

(cherry picked from 0853d2c1d849ef69884d2447d90d04007590b72b)

For cpuid leaf 0xb the bits 8-15 in ECX register define the end of counting
leaf.      The previous code was using bits 0-7 for this purpose, which is
a bug.

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1218,7 +1218,7 @@ static void do_cpuid_ent(struct kvm_cpui
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		/* read more entries until level_type is zero */
 		for (i = 1; *nent < maxnent; ++i) {
-			level_type = entry[i - 1].ecx & 0xff;
+			level_type = entry[i - 1].ecx & 0xff00;
 			if (!level_type)
 				break;
 			do_cpuid_1_ent(&entry[i], function, i);


