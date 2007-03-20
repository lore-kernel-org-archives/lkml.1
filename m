Return-Path: <linux-kernel-owner+w=401wt.eu-S933939AbXCTXeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939AbXCTXeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 19:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933933AbXCTXeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 19:34:12 -0400
Received: from gw.goop.org ([64.81.55.164]:48170 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933926AbXCTXeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 19:34:11 -0400
Message-ID: <46006F66.4030901@goop.org>
Date: Tue, 20 Mar 2007 16:33:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Matt Mackall <mpm@selenic.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       David Miller <davem@davemloft.net>, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, anthony@codemonkey.ws, netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <1174272469.11680.23.camel@localhost.localdomain> <m1648xxf93.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0703191134190.6730@woody.linux-foundation.org> <1174348905.11680.54.camel@localhost.localdomain> <45FF4043.4000805@vmware.com> <45FF770C.7050301@goop.org> <Pine.LNX.4.64.0703200805450.6730@woody.linux-foundation.org> <m1mz27sy82.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0703200903500.6730@woody.linux-foundation.org> <46000C7E.4070001@goop.org> <20070320224324.GL10459@waste.org> <46006963.1020401@vmware.com>
In-Reply-To: <46006963.1020401@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> I think Jeremy's idea was to have interrupt handlers leave interrupts
> disabled on exit if pda.intr_mask was set.  In which case, they would
> bypass all work and we could never get preempted.

Yes, I was worried that if we left the isr without actually handling the
interrupt, it would still be asserted and we'd just get interrupted
again.  The idea is that we avoid touching cli/sti for the common case
of no interrupts while interrupts are disabled, but we'd still need to
fall back to using them if an interrupt becomes pending.

> I don't think leaving hardware interrupts disabled for such a long
> time is good though. 

How long?  It would be no longer than now, and possibly less, wouldn't it?

    J
