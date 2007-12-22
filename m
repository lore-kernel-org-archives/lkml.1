Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbXLVBse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbXLVBse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbXLVBs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:48:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51764 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbXLVBs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:48:26 -0500
Date: Sat, 22 Dec 2007 02:49:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, mtk.manpages@googlemail.com,
       akpm@linux-foundation.org, lkml@davidb.org, paulus@samba.org,
       drepper@redhat.com, cfriesen@nortel.com, schwab@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Message-ID: <20071222014919.GA4477@one.firstfloor.org>
References: <476A53D4.7040909@gmail.com> <20071220.035104.240386115.davem@davemloft.net> <p73wsr7ef1h.fsf@bingen.suse.de> <20071221.174124.208826257.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221.174124.208826257.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm suggesting that you set the condition codes based upon whether
> there is an error or not. 

And the only way the syscall code could find out if there is an error is by
checking err < 0 && err >= -4096 like glibc (except for the compat
syscall on 64bit kernel case) 

Or rewrite all code that returns errors to system calls to pass
a separate flag too.

> That is the critical thing x86 doesn't do
> that all the other platforms do.

It doesn't do it because it's useless without a kernel rewrite.

I frankly doubt it really works on Sparc :-) Maybe it could work
there on a hypothetical rewritten kernel, but not today.

-Andi

