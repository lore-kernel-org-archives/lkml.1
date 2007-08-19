Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbXHSBe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbXHSBe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 21:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbXHSBes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 21:34:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:26126 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbXHSBer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 21:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WuoUIr573PRhpG5ZmCMGktwUKWBS15ocCgmm/k9nrvSfrsEXxsORNMDHpmOY193iDEnYTsuiehiJNwN9tSgjCOoFcALB7Ji/qnoK1+QYrXiryw6lndRcaJq7Cu5c2DDhV7t0iAGOjTkle7SdPitM+3GCd5NujMK2zafld7AEy2w=
Message-ID: <ab40e9c0708181834y7804a961p2c48a32a78fae688@mail.gmail.com>
Date: Sun, 19 Aug 2007 03:34:45 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: TIMER0 interrupt's problem in kernel 2.6.21 ( realview-smp_defconfig)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am running kernel 2.6.21 on my realview_eb_mpcore system.

at the beginning I found the program is stuck at calibrating
loop................, this is because that the timer0 didn't give out
any interrupt.

after enable the timer0's interrupt, I found that even when there is
no timer interrupt the interrupt routine (realview_timer_interrupt()
)is still reached.

I added a timer interrupt disable instruction in the routine
realview_timer_interrupt() , which makes sure that after the first
interrupt the interrupt would be disabled. even in this situation , I
can still see that the interrupt routine is accessed by the cpu.

I guess this maybe caused by the problem of the gic_ack() or some
other functions?

does anyone ever meet such a situation?

anyone knows how to handle this?

any idea is  appreciated.

regards,

Yang
