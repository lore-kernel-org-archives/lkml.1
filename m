Return-Path: <linux-kernel-owner+w=401wt.eu-S933681AbZD3Rks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681AbZD3Rks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764708AbZD3RIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:37 -0400
Received: from kroah.org ([198.145.64.141]:56865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764356AbZD3RIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:49 2009
Message-Id: <20090430165749.008682801@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:57:01 -0700
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
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, avi@redhat.com
Subject: [patch 72/88] KVM: PIT: fix i8254 pending count read
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-pit-fix-i8254-pending-count-read.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------


(cherry picked from d2a8284e8fca9e2a938bee6cd074064d23864886)

count_load_time assignment is bogus: its supposed to contain what it
means, not the expiration time.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/i8254.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -207,7 +207,7 @@ static int __pit_timer_fn(struct kvm_kpi
 	hrtimer_add_expires_ns(&pt->timer, pt->period);
 	pt->scheduled = hrtimer_get_expires_ns(&pt->timer);
 	if (pt->period)
-		ps->channels[0].count_load_time = hrtimer_get_expires(&pt->timer);
+		ps->channels[0].count_load_time = ktime_get();
 
 	return (pt->period == 0 ? 0 : 1);
 }


