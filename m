Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbZJTGMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbZJTGMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbZJTGM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:12:29 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:12571 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbZJTGM3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Tue, 20 Oct 2009 02:12:29 -0400
Message-Id: <4ADD7124020000780001AD37@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 20 Oct 2009 07:13:24 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Withdraw: [PATCH] x86-64: fix another kernel data leak to
	 32-bit processes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Unfortunately I didn't realize that the other instances of branches to
>int_ret_from_sys_call also need fixing when preparing the previous
>similar patch. The issue fixed here was in fact introduced by an
>earlier patch of mine (295286a89107c353b9677bc604361c537fd6a1c0, i.e.
>in 2.6.28, but through stable now also present in 2.6.27), making
>kernel stack contents potentially visible through R8...R11 when an
>this or earlier syscall got interrupted prior to the handler being able
>to decrement the stack pointer (such that the space normally used by
>those registers within pt_regs would get overwritten by the interrupt
>handler stub).

That analysis wasn't right after all - there's a CLEAR_RREGS in each of
the modified paths already, so the change is unnecessary (and adding
redundant code). Please don't apply it.

>While touching the code, I also swapped the branch pairs so that the
>static branch prediction logic would consider the syscall-number-in-
>range case the taken path.

If this would seem a worthwhile change, I can re-send it as a separate,
lower priority patch...

Jan

