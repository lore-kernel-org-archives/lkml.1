Return-Path: <linux-kernel-owner+w=401wt.eu-S934808AbYBTU7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934808AbYBTU7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934521AbYBTU7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:59:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59403 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934486AbYBTU7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:59:00 -0500
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sandmann@redhat.com,
       tglx@tglx.de, hpa@zytor.com
In-Reply-To: <20080220112655.18011dab@laptopd505.fenrus.org>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	 <1203531375.6243.52.camel@lappy>
	 <20080220103940.0a0b5ce0@laptopd505.fenrus.org>
	 <1203533622.6243.55.camel@lappy>
	 <20080220112655.18011dab@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 21:58:42 +0100
Message-Id: <1203541122.6243.103.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-20 at 11:26 -0800, Arjan van de Ven wrote:

> feel free to reinvent a whole GUI just to avoid a 200 line kernel module.
> sysprof is here. it works. 

> the gui is REALLY nice.

I guess we have to agree to disagree here. Its plain useless from my
POV.

> I think it's the wrong tradeoff though... oprofile exists for how long?

Dunno, years, and has served me well.

The thing I worry about is the wild-growth of duplicate functionality
and interfaces. You might say, 'its in /debug' so no API crap, but if
enough user-space depends on it people _will_ complain if it breaks.

Hopefully someone will consolidate stuff - soon. I can agree with the
fact that the oprofile user-interface is quite horrible, and perhaps the
kernel code isn't pretty (never looked at it), so if people want to
replace it, feel free, but offer a full replacement so we can deprecate
and remove the old stuff, and not carry everything around.

Currently we have: readprofile, oprofile, perfmon and now sysprof.

Also, sysprof is a misnomer, you cannot be a system wide profiler and
have code like:

+       if (!is_user) {
+               /* kernel */
+               trace->pid = current->pid;
+               trace->truncated = 0;
+               trace->n_addresses = 1;
+
+               /* 0x1 is taken by sysprof to mean "in kernel" */
+               trace->addresses[0] = 0x1;
+	}

The kernel is an integral part of the system, it can often help to know
where in the kernel time is spent - even if you're not directly
interested in 'fixing' the kernel.

