Return-Path: <linux-kernel-owner+w=401wt.eu-S935726AbXGQWda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935726AbXGQWda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbXGQWdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:33:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1189 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbXGQWdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:33:21 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 17 Jul 2007 15:33:12 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: signalfd and thread semantics
In-Reply-To: <469D2A40.2060008@gmx.net>
Message-ID: <Pine.LNX.4.64.0707171514290.26781@alien.or.mcafeemobile.com>
References: <469D2A40.2060008@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Michael Kerrisk wrote:

> Hi Davide,
> 
> Working on the signalfd man page, another question comes up:
> 
> What are the intended semantics for a signalfd file descriptor with respect
> to threads?  I have not yet tested the behavior, but in any case, I better
> check what is expected.
> 
> A signal can be directed to the process as a whole (e.g., using kill(2)),
> or to a particular thread (using, e.g., pthread_kill(2), or tgkill(2)).
> 
> So that raises the question: If a thread calls signalfd(), does the
> resulting file descriptor return just those signals directed to [the thread
> and the process as a whole], or will it also receive signals that are
> targeted at other threads in the process?  I would hope the former is the
> case, but I'm not sure what has been implemented (or intended).

If thread A calls signalfd(), a read() from the signalfd will return 
thread A private (tgkill) signals (only when called by thread A) and 
thread A shared (kill) signals (readable from any thread).
So a call to signalfd() virtually attaches the fd to the calling thread 
signal context.
This is the reason of the "virtual connection" dropped I was talking about 
in the other email. If the signal context the fd is attached to 
(struct sighand), goes away, the fd becomes like a disconnected socket 
with no peer to read form.



- Davide


