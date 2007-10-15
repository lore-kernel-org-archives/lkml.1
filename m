Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbXJOSOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbXJOSOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbXJOSO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:14:28 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:43496 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbXJOSO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:14:27 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 15 Oct 2007 11:14:24 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       lkml <linux-kernel@vger.kernel.org>,
       Subrata Modak <subrata@linux.vnet.ibm.com>, geoff@gclare.org.uk,
       Christoph Hellwig <hch@lst.de>
Subject: Re: Revised signalfd man-page
In-Reply-To: <47130EA1.6000300@gmail.com>
Message-ID: <Pine.LNX.4.64.0710151103591.5204@alien.or.mcafeemobile.com>
References: <46FB9FB9.8080201@gmx.net> <Pine.LNX.4.64.0709271000420.763@alien.or.mcafeemobile.com>
 <47130EA1.6000300@gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Michael Kerrisk wrote:

> Hi Davide,
> 
> There were two questions that you overlooked in my earlier draft of the
> signalfd man page.  I've revised one of the questions slightly.  Could you
> look at these please:

I think I already answered those, no? Anyway ...



> .SS execve(2) semantics
> [TO BE COMPLETED]
> .\" FIXME
> .\" Davide, what are the intended semantics after an execve()?
> .\" I would hope that the descriptor remains available, and can
> .\" be used to read any queued signals.  This is analogous with
> .\" traditional behavior, where blocked signals that are pending
> .\" prior to an execve() remain pending after the execve().
> .\"
> .\" Below, was my original question, based on how things
> .\" worked at one point, but perhaps they have changed by now:
> .\"===
> .\" As far as I can work out, after an execve() the file descriptor
> .\" is still available, but reads from it always return 0, even if:
> .\"
> .\" a) there were signals pending before the execve().
> .\"    However, sigpending() shows the signal as pending,
> .\"    and the signal can be accepted using sigwaitinfo().
> .\"
> .\" b) we generate the signal after the exec.
> .\"
> .\" Is this intended behavior (the "orphaned sighand" condition
> .\" described above?)?  Is it a bug?

With the new code Linus already merged, signalfd does not attach to the 
sighand anymore, so the "orphaned sighand" behaviour is no more there.
An exec() will carry the fd over, and you will be able to use the fd in 
the same way you did before the exec(). If sigpending()/sigwaitinfo() will 
show signals available, so it should signalfd.



> .SS Thread semantics
> [TO BE COMPLETED]
> .\" FIXME Davide, a signal can be directed to the process as
> .\" a whole, or to a particular thread.  What are the intended
> .\" semantics for signalfd()?  If a thread calls signalfd(),
> .\" does the resulting file descriptor return just those
> .\" signals directed to [the thread and the process as a whole],
> .\" or will it also receive signals that are targeted at
> .\" other threads in the process?

It'll return the signals that would be normally returned to the thread 
with the standard signal delivery methods. That is, calling thread private 
signals, and calling thread-group shared signals.



- Davide


