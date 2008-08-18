Return-Path: <linux-kernel-owner+w=401wt.eu-S1762060AbYHRTA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762060AbYHRTA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223AbYHRS6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:58:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:36576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbYHRS6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:58:34 -0400
Date: Mon, 18 Aug 2008 11:44:38 -0700
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
       alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 34/60] KVM: task switch: translate guest segment limit to
	virt-extension byte granular field
Message-ID: <20080818184438.GI29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-task-switch-translate-guest-segment-limit-to-virt-extension-byte-granular-field.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit c93cd3a58845012df2d658fecd0ac99f7008d753)

If 'g' is one then limit is 4kb granular.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3168,6 +3168,10 @@ static void seg_desct_to_kvm_desct(struc
 	kvm_desct->base |= seg_desc->base2 << 24;
 	kvm_desct->limit = seg_desc->limit0;
 	kvm_desct->limit |= seg_desc->limit << 16;
+	if (seg_desc->g) {
+		kvm_desct->limit <<= 12;
+		kvm_desct->limit |= 0xfff;
+	}
 	kvm_desct->selector = selector;
 	kvm_desct->type = seg_desc->type;
 	kvm_desct->present = seg_desc->p;

-- 
