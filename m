Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbXKSNFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbXKSNFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXKSNF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:05:26 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:26137 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbXKSNFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:05:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mVThnXRyUmYke5ZOp5epoheM3tiOrxjicgn9dUYfyxi1c53CBX8PV9Uz28nZ415K5zkMjAi2Gqs9pxtyhB+cLQsnWlSviIg+1euMU+SOaA9do6FE5cFtOMbw9ivpDVbsbyxj1Gm4ZYEQe82uQaerRBTrS0drYiaOlKM+2anm4p4=
Message-ID: <47418A00.1000704@gmail.com>
Date: Mon, 19 Nov 2007 14:05:04 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: apm emulation driver broken ?
References: <cda58cb80711160706l2cfac2b1p81c7a1090f228f2e@mail.gmail.com> <200711171346.51363.rjw@sisk.pl> <4740992D.9030906@gmail.com> <200711182322.41354.rjw@sisk.pl>
In-Reply-To: <200711182322.41354.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 18 of November 2007, Franck Bui-Huu wrote:
>> Rafael J. Wysocki wrote:
>> See the call to wait_even() made by apm_ioctl(). If any processes
>> run this, it will prevent the system to suspend...
> 
> True, but does it actually happen in practice?
> 

when several processes are waiting for a suspend event.

> 
> At this point the second branch of the "if (as->suspend_state == SUSPEND_READ)"
> can be fixed by replacing wait_event_interruptible() with
> wait_event_freezable(), 

yes

> but the fix for the first branch depends on whether or
> not the wait_event() is really necessary.

As I said I don't know. It's probably time to put some people
on CC but don't know who though.

> 
> If it can be replaced with an interruptible sleep, we can use
> wait_event_freezable() in this case too.  Otherwise, the only woking fix would
> be to reintroduce the PF_NOFREEZE in there.

BTW, why not raising PF_NOFREEZE in wait_event(), so thread sleeping
in UNINTERRUPTIBLE state won't prevent suspend to happen ?


		Franck
