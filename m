Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYKZI4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYKZI4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYKZI4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:56:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35497
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbYKZI4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:56:07 -0500
Date: Wed, 26 Nov 2008 00:56:07 -0800 (PST)
Message-Id: <20081126.005607.141892563.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/32] sparc32 cpuinit flase positives
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1L3wMk-0006Iq-IO@ZenIV.linux.org.uk>
References: <E1L3wMk-0006Iq-IO@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:33:54 +0000

> 
> All noise since we don't have CPU hotplug there.  However, they
> did expose something very odd-looking in there - poke_viking()
> does a bunch of identical btfixup each time it's called (i.e.
> for each CPU).  That one is left alone for now; just the trivial
> misannotation fixes.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied, thanks Al.

The local MMU register inits do need to happen for all cpus,
so what I'll do is move the btfixups to where we assign
poke_srmmu to poke_viking, so that they occur only once.
