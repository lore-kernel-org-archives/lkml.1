Return-Path: <linux-kernel-owner+w=401wt.eu-S933449AbZD3RgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbZD3RgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764703AbZD3RI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:28 -0400
Received: from kroah.org ([198.145.64.141]:56788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764659AbZD3RIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:47 2009
Message-Id: <20090430165747.846541379@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:53 -0700
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
       alan@lxorguk.ukuu.org.uk, Wu Fengguang <fengguang.wu@intel.com>,
       mtosatti@redhat.com, Wu Fengguang <wfg@linux.intel.com>, avi@redhat.com
Subject: [patch 64/88] KVM: Prevent trace call into unloaded module text
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-prevent-trace-call-into-unloaded-module-text.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

(cherry picked from b82091824ee4970adf92d5cd6d57b12273171625)

Add marker_synchronize_unregister() before module unloading.
This prevents possible trace calls into unloaded module text.

Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 virt/kvm/kvm_trace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/virt/kvm/kvm_trace.c
+++ b/virt/kvm/kvm_trace.c
@@ -252,6 +252,7 @@ void kvm_trace_cleanup(void)
 			struct kvm_trace_probe *p = &kvm_trace_probes[i];
 			marker_probe_unregister(p->name, p->probe_func, p);
 		}
+		marker_synchronize_unregister();
 
 		relay_close(kt->rchan);
 		debugfs_remove(kt->lost_file);


