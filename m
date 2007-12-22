Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbXLVBpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbXLVBpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbXLVBpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:45:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58318
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbXLVBps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:45:48 -0500
Date: Fri, 21 Dec 2007 17:45:47 -0800 (PST)
Message-Id: <20071221.174547.136433173.davem@davemloft.net>
To: andi@firstfloor.org
Cc: mtk.manpages@googlemail.com, akpm@linux-foundation.org, lkml@davidb.org,
       paulus@samba.org, drepper@redhat.com, cfriesen@nortel.com,
       schwab@suse.de, linux-kernel@vger.kernel.org
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071221.174124.208826257.davem@davemloft.net>
References: <20071220.035104.240386115.davem@davemloft.net>
	<p73wsr7ef1h.fsf@bingen.suse.de>
	<20071221.174124.208826257.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 21 Dec 2007 17:41:24 -0800 (PST)

> I'm suggesting that you set the condition codes based upon whether
> there is an error or not.  That is the critical thing x86 doesn't do
> that all the other platforms do.

And if you still don't get it, I'm saying that x86, in the syscall
trap return path, should set the conditon codes based upon whether the
system call is really signalling an error or not.

And to handle potentially ambiguous cases we, for a long time, have
the force_successful_syscall_return() arch hook.  System call
implementations use this when the return values they give could be
mis-construed as error values.

And if you'll notice x86 makes no attempt to implement that hook,
because it currently can't.  That's what needs to be fixed.
