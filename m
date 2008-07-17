Return-Path: <linux-kernel-owner+w=401wt.eu-S932502AbYGQWIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbYGQWIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757678AbYGQWHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:07:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:58168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501AbYGQWHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:07:53 -0400
Date: Fri, 18 Jul 2008 00:07:45 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       vgoyal@redhat.com
Subject: kdump: Report actual value of VMCOREINFO_OSRELEASE in VMCOREINFO
Message-ID: <20080718000745.51d32607@kopernikus.site>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation reports the structure name as
VMCOREINFO_OSRELEASE in VMCOREINFO, e.g.

        VMCOREINFO_OSRELEASE=init_uts_ns.name.release

That doesn't make sense because it's always the same. Instead, use the
value, e.g.

        VMCOREINFO_OSRELEASE=2.6.26-rc3

That's also what the 'makedumpfile -g' does.

Signed-off-by: Bernhard Walle <bwalle@suse.de>

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 3265968..3c7784d 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -127,8 +127,8 @@ void vmcoreinfo_append_str(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
 unsigned long paddr_vmcoreinfo_note(void);
 
-#define VMCOREINFO_OSRELEASE(name) \
-	vmcoreinfo_append_str("OSRELEASE=%s\n", #name)
+#define VMCOREINFO_OSRELEASE(value) \
+	vmcoreinfo_append_str("OSRELEASE=%s\n", value)
 #define VMCOREINFO_PAGESIZE(value) \
 	vmcoreinfo_append_str("PAGESIZE=%ld\n", value)
 #define VMCOREINFO_SYMBOL(name) \
