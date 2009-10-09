Return-Path: <linux-kernel-owner+w=401wt.eu-S1761705AbZJIXRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761705AbZJIXRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761675AbZJIXRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:32 -0400
Received: from kroah.org ([198.145.64.141]:36843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761663AbZJIXRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:02 2009
Message-Id: <20091009231002.392026141@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Aurelien Jarno <aurelien@aurel32.net>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 18/26] KVM: fix LAPIC timer period overflow
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-lapic-timer-period-overflow.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Aurelien Jarno <aurelien@aurel32.net>

commit b2d83cfa3fdefe5c6573d443d099a18dc3a93c5f upstream.

Don't overflow when computing the 64-bit period from 32-bit registers.

Fixes sourceforge bug #2826486.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/lapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -567,7 +567,7 @@ static void start_apic_timer(struct kvm_
 {
 	ktime_t now = apic->lapic_timer.timer.base->get_time();
 
-	apic->lapic_timer.period = apic_get_reg(apic, APIC_TMICT) *
+	apic->lapic_timer.period = (u64)apic_get_reg(apic, APIC_TMICT) *
 		    APIC_BUS_CYCLE_NS * apic->divide_count;
 	atomic_set(&apic->lapic_timer.pending, 0);
 


