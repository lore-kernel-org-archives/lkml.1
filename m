Return-Path: <linux-kernel-owner+w=401wt.eu-S1760750AbZFKIJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbZFKIJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760272AbZFKIJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:09:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759462AbZFKIJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:09:01 -0400
Subject: RE: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch
 trace support"
From: Peter Zijlstra <peterz@infradead.org>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EBBC6546E@irsmsx504.ger.corp.intel.com>
References: <tip-511b01bdf64ad8a38414096eab283c7784aebfc4@git.kernel.org>
	 <928CFBE8E7CB0040959E56B4EA41A77EBBC6544B@irsmsx504.ger.corp.intel.com>
	 <1244702183.6691.8.camel@laptop>
	 <928CFBE8E7CB0040959E56B4EA41A77EBBC6546E@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 10:08:55 +0200
Message-Id: <1244707735.6691.16.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 08:17 +0100, Metzger, Markus T wrote:
> >That would indeed keep the proposed ABI workable, what I'm still not
> >liking is that this buffer is in-kernel, but I guess that might be
> >something for other people to have an opinion on.
> 
> The alternative would be to give a user-allocated buffer to the tracing h/w.
> 
> We would need to take precautions to prevent the user from messing around
> with that buffer while the h/w is writing to it. Other code uses the kernel-
> allocated buffer plus copy_to_user() approach, as well.
> 
> Further, it would require the user to interpret the various tracing formats,
> whereas the existing interface provides an architecture-independent format.
> 
> 
> Does anybody have concerns on using an in-kernel buffer and providing a 
> copy_to_user() interface?

Ah, if you mmap() you can do without copy_to_user().

Either way, you have to make sure the buffer is mlocked() anyway, since
you're wanting to fill it from interrupt context.

The advantage (imo) from letting the user set it up is that you don't
need those separate allocation routines.

But yes, it would expose the data to the user, but one could keep it
opaque data, without requiring the user to be able to interpret it.

Of course a data format aligned with the interface capabilities would be
nicer ;-)

