Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbZEUWyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbZEUWyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbZEUWyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:54:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35271 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755081AbZEUWyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:54:09 -0400
Date: Thu, 21 May 2009 23:54:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Simon Holm =?ISO-8859-14?B?VGj4Z2Vyc2Vu?= <odie@cs.aau.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Jean-Paul Calderone <exarkun@twistedmatrix.com>
Subject: Re: Allow signaling a process by all its thread ids?
Message-ID: <20090521235428.53b71862@lxorguk.ukuu.org.uk>
In-Reply-To: <1242944179.10298.11.camel@odie.local>
References: <1242944179.10298.11.camel@odie.local>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It may be that POSIX is weakly worded enough that either allowing or
> disallowing this behavior is valid.  I think that allowing it is a
> violation of POSIX, but I can find no single, explicit, direct statement
> in POSIX to back this up.

If there was a specific explicit statement it might be an argument to add
a separate poxix_kill(), but the existing kill(2) interface the kernel
has is API, its been that way forever and you need *very* strong reasons
to make such changes that might break things.

You need to show that
- The current API breaks stuff
- The current API is absolutely invalid in posix
- Changing it improves the functionality and power of the kernel
- Changing it doesn't break existing applications

> There is at least one other argument to disallow this behavior even if
> it is not technically illegal.  Consider the traditional, widespread
> convention of pid files.  This behavior drastically reduces their
> utility, as it greatly increases the chance of PID collisions, a case in
> which it is difficult to automatically (that is, without human
> intervention) recognize that a pid file no longer corresponds to a
> running process which created it.  This is the case in which I
> encountered the behavior - when it repeatedly caused services not to
> restart because they encountered a thread of another process and
> misinterpreted it to mean the service was already running.

Either your pid files are secure, or they are not. If collisions can
occur by accident I can cause them deliberately. If I can cause them
deliberately your system is insecure and you need to fix it.

