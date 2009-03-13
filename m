Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbZCMJZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbZCMJZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZCMJZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:25:20 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:22074 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZCMJZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:25:19 -0400
Message-Id: <49BA33BE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 13 Mar 2009 09:21:50 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, "Peter Zijlstra" <peterz@infradead.org>,
       <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [tip:core/ipi] generic-ipi: eliminate spurious
	 pointlessWARN_ON()s
References: <49B91A7E.76E4.0078.0@novell.com>
 <tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org>
 <1236934491.5188.209.camel@laptop>
In-Reply-To: <1236934491.5188.209.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Peter Zijlstra <peterz@infradead.org> 13.03.09 09:54 >>>
>Wouldn't leaving them in place but changing them to:
>
>WARN_ON(irqs_disabled() && system_state == SYSTEM_RUNNING);
>
>be clearer?

I don't think that would be precise: system_state gets set to
SYSTEM_RUNNING much later than APs get brought up (i.e. there are
cases where the WARN_ON()s could validly trigger with SYSTEM_BOOTING),
and also doesn't cover states > SYSTEM_RUNNING (where, again, after
perhaps having brought down all APs the warnings could become pointless,
but the warnings could be meaningful as long as there are still some APs
online).

While from an abstract code reading perspective your suggestion might
seem reasonable, the changed placement really reflects what the warning
is trying to warn about - a potential deadlock which cannot occur under
the conditions filtered out by conditionals the warnings were moved
beyond.

Jan

