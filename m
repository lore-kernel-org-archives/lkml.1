Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab0CJRH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:07:57 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44213 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab0CJRH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:07:56 -0500
To: ijc@hellion.org.uk
Cc: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, x86@kernel.org
Subject: Re: [PATCH] x86: namespace some I/O APIC related structures and functions.
References: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
	<1268218559-26784-1-git-send-email-ijc@hellion.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 10 Mar 2010 09:07:44 -0800
In-Reply-To: <1268218559-26784-1-git-send-email-ijc@hellion.org.uk> (ijc@hellion.org.uk's message of "Wed\, 10 Mar 2010 10\:55\:57 +0000")
Message-ID: <m1d3zcksv3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: ijc@hellion.org.uk, x86@kernel.org, jeremy@goop.org, yinghai@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, ian.campbell@citrix.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ijc@hellion.org.uk writes:

> From: Ian Campbell <ian.campbell@citrix.com>
>
> It is not obvious that certain functions relate specifically to the
> I/O APIC. Rename structures and functions as follows:
>
>   struct irq_cfg -> struct ioapic_irq_cfg
>   irq_cfg() -> ioapic_irq_cfg()
>   assign_irq_vector() -> ioapic_assign_irq_vector()
>   send_cleanup_vector() -> ioapic_send_cleanup_vector()
>
> There is a slight preference towards ioapic vs io_apic in the current
> code (563 occurances vs 146) so I went with that.

The rename is wrong.  Only the optional irq_2_pin list in struct
irq_cfg is specific to ioapics.

The rest of the fields are all about the architectural vector based
interrupt delivery system of x86.  Branding that structure with ioapic
is strongly misleading.

x86_irq_cfg might be an appropriate rename.

Eric
