Return-Path: <linux-kernel-owner+w=401wt.eu-S1763555AbXGNSxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763555AbXGNSxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 14:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759937AbXGNSxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 14:53:39 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4425 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759765AbXGNSxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 14:53:38 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 14 Jul 2007 11:53:35 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: signalfd() semantics after execve()
In-Reply-To: <20070714074145.277260@gmx.net>
Message-ID: <Pine.LNX.4.64.0707141151500.31255@alien.or.mcafeemobile.com>
References: <20070714074145.277260@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007, Michael Kerrisk wrote:

> Davide, 
> 
> I'm working on the signalfd(2) man page, and I've come
> acorss some puzzling behaviour...  
> 
> What are the intended semantics of a signalfd file descriptor
> after an execve()?
> 
> As far as I can work out, after an execve() the file descriptor
> is still available, but reads from it always return 0, even if:
> 
> a) there were signals pending before the execve().
>    However, sigpending() shows the signal as pending,
>    and the signal can be accepted using sigwaitinfo().
> 
> b) we generate a signal after the execve().
>  
> Is this intended behavior (the "orphaned sighand" condition
> mentioned in the draft man page you sent me?)?  Is it a bug?

It is the intended behaviour. Just like reading from a socket where the 
remote peer disconnected. A return 0 from a read from a signalfd should be 
interpreted as the "virtual connection" with the signal source has been 
dropped.



- Davide


