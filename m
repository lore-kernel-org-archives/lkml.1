Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbZCRWPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbZCRWPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbZCRWP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:15:29 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50274 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbZCRWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:15:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18881.29300.669876.820286@cargo.ozlabs.ibm.com>
Date: Thu, 19 Mar 2009 09:15:16 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/11] perf_counter: revamp syscall input ABI
In-Reply-To: <1237366063.5069.64.camel@laptop>
References: <20090317215606.037073805@chello.nl>
	<20090317220421.336322251@chello.nl>
	<18880.23662.233043.833458@drongo.ozlabs.ibm.com>
	<1237366063.5069.64.camel@laptop>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Ah, I thought we should keep a pure 64 bit raw value. You never know
> what hardware will do.

Oh I see, you use hw_event->raw_event if hw_event->raw is set.  I
missed that before.

Still, you're putting that into hwc->config along with other bits like
ARCH_PERFMON_EVENTSEL_USR and ARCH_PERFMON_EVENTSEL_OS, so I would
think we could spare two bits for the type, leaving 62 bits for the
raw event code.  And if that isn't enough, there's the
hw_event.extra_config_len field, which allows userspace to pass in
arbitrary amounts of extra PMU configuration data.

Paul.
