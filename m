Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbXLFTA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbXLFTA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXLFTAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:00:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbXLFTAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:00:51 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com
Subject: [PATCH 0/19] desc_struct integration
Date: Thu,  6 Dec 2007 14:16:21 -0200
Message-Id: <1196957800568-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a series of patches that unify the struct desc_struct and friends
across x86_64 and i386. As usual, it provides paravirt capabilities as a
side-effect for x86_64.

I consider the main goal, namely, of unifying the desc_struct, an ongoing
effort, being this the beginning. A lot of old code has to be touched to
accomplish that. 

I don't consider this patch ready for inclusion. Basically, the main reason
is that I change the signatures of write_idt_entry(), write_gdt_entry(), and
write_ldt_entry(). This is needed to account for the differences between the
two architectures. (For example, gate descriptors in x86_64 are 16-byte long
and can't be represented by low and high entries). As my patch series were
64-bit only, I hadn't come across the problem before.

I think this interface is sane, but I'd like to hear opinions. Specially
from Jeremy and Zach, since it would touch xen and vmi code. The later, by
the way, is _not_ included in this series. Being the interface acked, we
still have to write it.

Thanks in advance for the review in opinions to come.


