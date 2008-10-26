Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYJZSDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYJZSDC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:03:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYJZSCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:02:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbYJZSCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:02:50 -0400
Date: Sun, 26 Oct 2008 11:01:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, "Mikko C." <mikko.cal@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug in workqueues [was: Usb devices randomly aren't detected
 with 2.6.28-rc1-git1]
In-Reply-To: <200810261855.47580.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0810261057290.5200@nehalem.linux-foundation.org>
References: <Pine.LNX.4.44L0.0810261327170.25044-100000@netrider.rowland.org> <200810261855.47580.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 26 Oct 2008, Rafael J. Wysocki wrote:
> > 
> > So apparently flush_workqueue() isn't working.
> 
> Let's make that more visible (adding CCs). :-)

Isn't this the same thing that was fixed by commit 
4403b406d4369a275d483ece6ddee0088cc0d592: aka 'Revert "Call 
init_workqueues before pre smp initcalls."'

The bug was that init_workqueues was called too early, causing it to have 
wrong initialization of its CPU masks, which caused various random 
problems since it wouldn't run workqueues on anything but the boot CPU.

It is hidden by various config options (eg if you enable suspend, for 
example), which is why it probably took some time for people to notice.

		Linus
