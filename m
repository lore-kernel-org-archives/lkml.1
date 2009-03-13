Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZCMJoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZCMJoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZCMJo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:44:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:38074 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZCMJo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:44:28 -0400
Subject: Re: [tip:core/ipi] generic-ipi: eliminate spurious
 pointlessWARN_ON()s
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <49BA33BE.76E4.0078.0@novell.com>
References: <49B91A7E.76E4.0078.0@novell.com>
	 <tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org>
	 <1236934491.5188.209.camel@laptop>  <49BA33BE.76E4.0078.0@novell.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Mar 2009 10:43:43 +0100
Message-Id: <1236937423.22914.3698.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 09:21 +0000, Jan Beulich wrote:
> >>> Peter Zijlstra <peterz@infradead.org> 13.03.09 09:54 >>>
> >Wouldn't leaving them in place but changing them to:
> >
> >WARN_ON(irqs_disabled() && system_state == SYSTEM_RUNNING);
> >
> >be clearer?
> 
> I don't think that would be precise: system_state gets set to
> SYSTEM_RUNNING much later than APs get brought up (i.e. there are
> cases where the WARN_ON()s could validly trigger with SYSTEM_BOOTING),
> and also doesn't cover states > SYSTEM_RUNNING (where, again, after
> perhaps having brought down all APs the warnings could become pointless,
> but the warnings could be meaningful as long as there are still some APs
> online).
> 
> While from an abstract code reading perspective your suggestion might
> seem reasonable, the changed placement really reflects what the warning
> is trying to warn about - a potential deadlock which cannot occur under
> the conditions filtered out by conditionals the warnings were moved
> beyond.

How about?

WARN_ON_ONCE(irqs_disabled() && !oops_in_progress)


