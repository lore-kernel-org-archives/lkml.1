Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbZA3DIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbZA3DIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 22:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZA3DIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 22:08:02 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:34509 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752580AbZA3DIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 22:08:00 -0500
Date: Fri, 30 Jan 2009 06:07:58 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: 2.6.28-rt on PowerPC
Message-ID: <20090130030758.GA7004@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090129213429.GA29014@oksana.dev.rtsoft.ru> <1233281510.18767.17.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1233281510.18767.17.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 01:11:50PM +1100, Benjamin Herrenschmidt wrote:
> 
> > This is trivially solved by converting arch/powerpc/sysdev/ipic.c
> > back to spinlocks (ipic_lock).
> > 
> > Assuming that converting-back is automatic, there are few other
> > chained interrupt controllers you might want to convert-back:
> > 
> > arch/powerpc/sysdev/i8259.c (i8259_lock)
> > arch/powerpc/sysdev/mpic.c (mpic_lock)
> > arch/powerpc/sysdev/qe_lib/qe_ic.c (qe_ic_lock)
> 
> Except that a bunch of those can be both primary and chained...

Yeah, thanks for correcting.

> It's
> simply not a solution to have to "convert" interrupt controller code to
> use a different locking scheme depending on whether they are chained or
> primary...

Actually, it doesn't matter whether a controller is a root IC or
cascaded. Just as primary handlers, chained handlers don't run in
threads, thus spinlocks should be used, not sleeping locks.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
