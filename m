Return-Path: <linux-kernel-owner+w=401wt.eu-S1762773AbZATVL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762773AbZATVL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 16:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758428AbZATVLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 16:11:50 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:39592 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060AbZATVLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 16:11:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T8UAelbpBAj2F5WYXyQ+N2QGNKJPUHAvwDGNlFR+9YztkEI5SnrgvNbECRFasY8Y3C
         QoRMXLUm6B6j1crkskmbhFQASNzv2J7/T61/Q9Uh0r9E05xz59RMsMrReehSidD7+xAJ
         ZsSrcYb6hYASGSfT0jNwJj79yzq/mCYq17cI4=
Message-ID: <19f34abd0901201311t2425056dia6182812f7270297@mail.gmail.com>
Date: Tue, 20 Jan 2009 22:11:47 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: lockdep and debug objects together are broken?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090120085559.GB19505@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090120085559.GB19505@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 9:55 AM, Nick Piggin <npiggin@suse.de> wrote:
> Hi,
>
> I've had a problem frustrating my testing because lockdep was silently turning
> itself off... I patched out the code to disable lockdep after the first error,
> and it started showing up weird errors. kernel/fork.c:990 seemed to be the
> first to trigger (hard irqs disabled) from a call_usermodehelper call. Later,
> migration thread was reported to try to unlock rq->lock although it was
> holding no locks. Then init was reported to return to userspace without
> releasing an objectdebug hash lock.
>
> All that went away and everything seemed to work properly with debug objects
> configured out.
>
> I didn't get too far in trying to debug the problem. But it should be easy
> enough to reproduce (if not, I can post traces or test patches).

I just built a kernel with lockdep and debugobjects enabled, and
everything seemed fine. I think you should post your kernel version,
config, and the lockdep patch (if needed -- it didn't seem to turn
itself off here).


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
