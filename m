Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab0BWTTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:19:18 -0500
Received: from david.siemens.de ([192.35.17.14]:15870 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab0BWTTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:19:17 -0500
Message-ID: <4B842A1F.50601@siemens.com>
Date: Tue, 23 Feb 2010 20:18:55 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
       RT <linux-rt-users@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: kvm: Convert i8254/i8259 locks to raw_spinlocks
References: <20100217135901.331576359@linutronix.de>
In-Reply-To: <20100217135901.331576359@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> The i8254/i8259 locks need to be real spinlocks on preempt-rt. Convert
> them to raw_spinlock. No change for !RT kernels.

Doesn't fly for -rt anymore: pic_irq_update runs under this raw lock and
calls kvm_vcpu_kick which tries to wake_up some thread -> scheduling
while atomic.

This used to work up to 956f97cf. -rt for 2.6.31 is not yet affected,
but 2.6.33 should be broken (haven't checked, using kvm-kmod over 2.6.31
ATM). I can provide a patch that restores the deferred kicking if it's
acceptable for upstream.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
