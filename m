Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbYAUGYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbYAUGYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 01:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYAUGXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 01:23:55 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:49512 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbYAUGXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 01:23:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=I0+r/SUcIaXgHuYt2ujuqEnLVMNKZQTDqzomQWTQleSVZuNOanSdRYQHHhK3EyvRAv4OVs9Kre7z2rT+KnLJhd/a0H0x8uJLUVGDqDiWeU+ho/BkhlWQUu9YSo+p013urGO0fhoSAqAPaCvYUu9HsLUhpqoTxlBHAdbr7skt6cU=
Message-ID: <4104961b0801202223w1d739365s2bd0ce552a22da19@mail.gmail.com>
Date: Mon, 21 Jan 2008 14:23:51 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question about set_intr_gate_ist()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I know there is set_intr_gate(n,addr) which is used to insert an
interrupt gate in the n th IDT entry. But I don't know what the usage
of set_intr_gate_ist()?

  Take the code below for example,
static inline void set_intr_gate_ist(int nr, void *func, unsigned ist)
{
	BUG_ON((unsigned)nr > 0xFF);
	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, ist);
}
  What does "ist" mean?
  In particular, note that this function is used only in x86_64 arch.
Can anyone explain this for me, thanks.

localhost:/usr/src/linux-2.6.22.1 # grep -r set_intr_gate_ist *
arch/x86_64/kernel/traps.c:     set_intr_gate_ist(1,&debug,DEBUG_STACK);
arch/x86_64/kernel/traps.c:     set_intr_gate_ist(2,&nmi,NMI_STACK);
arch/x86_64/kernel/traps.c:     set_intr_gate_ist(8,&double_fault,
DOUBLEFAULT_STACK);
arch/x86_64/kernel/traps.c:
set_intr_gate_ist(12,&stack_segment,STACKFAULT_STACK);
arch/x86_64/kernel/traps.c:     set_intr_gate_ist(18,&machine_check, MCE_STACK);
include/asm-x86_64/desc.h:static inline void set_intr_gate_ist(int nr,
void *func, unsigned ist)


Regards
Jason
