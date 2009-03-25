Return-Path: <linux-kernel-owner+w=401wt.eu-S1762751AbZCYOWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762751AbZCYOWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762155AbZCYOTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:19:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:33962 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762209AbZCYOTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:19:00 -0400
Subject: RE: [patch 3/9] LTTng instrumentation tasklets
From: Peter Zijlstra <peterz@infradead.org>
To: Chetan.Loke@Emulex.Com
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       fweisbec@gmail.com, jbaron@redhat.com, tglx@linutronix.de,
       rmk+lkml@arm.linux.org.uk, mhiramat@redhat.com, fche@redhat.com,
       haoki@redhat.com, t-nishiie@np.css.fujitsu.com, rostedt@goodmis.org,
       eduard.munteanu@linux360.ro
In-Reply-To: <BD597E014482714090555A6376F9CA8B771BE5A0BD@EXMAIL.ad.emulex.com>
References: <20090324155625.420966314@polymtl.ca>
	 <20090324160148.238795468@polymtl.ca> <20090324175621.GE31117@elte.hu>
	 <BD597E014482714090555A6376F9CA8B771BE5A0BD@EXMAIL.ad.emulex.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 25 Mar 2009 15:17:58 +0100
Message-Id: <1237990678.7972.1094.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 06:52 -0700, Chetan.Loke@Emulex.Com wrote:
> Quick question. I understand this is unrelated to this patch. So I
> apologize in advance.
> Ingo - you mentioned "tasklets are a legacy mechanism". Is there a
> plan to phase them out ? Let me draw a small picture as to what's
> bothering me.
> 
> With the SR-IOV support if there are 'N' virtual functions then there
> will be 'N' driver instances(actually N+1, 1 for the PF). If that
> driver drains the responses in the interrupt context then all such
> VF-instances could virtually block everyone else(because SR-IOV guys
> might also have MSI-X enabled).
> So now all such drivers should alter their Rx path.Driver's can queue
> tasklets and can also get the performance they want.
> 
> Any suggestions?

Threaded interrupts?
