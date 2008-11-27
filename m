Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYK0OGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYK0OGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYK0OGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:06:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59296 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbYK0OGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:06:06 -0500
Date: Thu, 27 Nov 2008 15:16:37 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm
Subject: Re: [PATCH 2/5] x86: ret_from_fork - get rid of jump back
Message-ID: <20081127141637.GQ6703@one.firstfloor.org>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com> <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com> <874p1u45ke.fsf@basil.nowhere.org> <20081126201054.GB2624@localhost> <20081127134121.GA22736@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127134121.GA22736@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But it gets worse than that: checking for _TIF_SYSCALL_TRACE is 
> completely unnecessary here because we clear that flag for every 

That's true. I found your 2005 changeset which did that, although
it seems to have been written before meaningful changelogs
became en vogue so it's unclear why. But assuming strace/gdb
always reattach it's probably ok.

But _TIF_SYSCALL_AUDIT for which it also checks is not always cleared so 
it's not completely dead. 

That said in theory the ret_from_sys checks should handle those too, 
so it might be unnecessary (I don't remember why I added the additional
check here).  Still removing it  would change the order
of signal checks versus trace checks and since signal
handling is always hairy one would need to be very careful
when changing it to not break anything.

-Andi
