Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbZFIK04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbZFIK04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760686AbZFIKTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:19:48 -0400
Received: from kroah.org ([198.145.64.141]:54922 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760724AbZFIKTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:19:47 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:02 2009
Message-Id: <20090609094101.891768425@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:30 -0700
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
       alan@lxorguk.ukuu.org.uk, Avi Kivity <avi@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 42/87] KVM: Explicity initialize cpus_hardware_enabled
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=kvm-explicity-initialize-cpus_hardware_enabled.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit a4c0364be3f43d3e17fe19270f8b3d64881606e6 upstream.

Under CONFIG_MAXSMP, cpus_hardware_enabled is allocated from the heap and
not statically initialized.  This causes a crash on reboot when kvm thinks
vmx is enabled on random nonexistent cpus and accesses nonexistent percpu
lists.

Fix by explicitly clearing the variable.

Reported-and-tested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 virt/kvm/kvm_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2315,6 +2315,7 @@ int kvm_init(void *opaque, unsigned int 
 		r = -ENOMEM;
 		goto out_free_0;
 	}
+	cpumask_clear(cpus_hardware_enabled);
 
 	r = kvm_arch_hardware_setup();
 	if (r < 0)


