Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYENWPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYENWPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYENWPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:15:05 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:42925 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbYENWPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:15:04 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
From: Andi Kleen <andi@firstfloor.org>
References: <20080514174955.GA515@elte.hu> <20080514224600.5bb5db5c@core>
Date: Thu, 15 May 2008 00:15:02 +0200
In-Reply-To: <20080514224600.5bb5db5c@core> (Alan Cox's message of "Wed, 14 May 2008 22:46:00 +0100")
Message-ID: <877idw7ct5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 May 2008 22:08:02.0084 (UTC) FILETIME=[FA0A5E40:01C8B60E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> Out of amusement I took the watchdog drivers and started looking for
> large cans of worms in the BKL drop arena.
>
> Here is a fun one for general discussion - right now driver probe
> functions request resources. We have no ordering on the requests so we
> have deadlocks if two drivers do resource requests for conflicting
> resources in reverse order.

What deadlocks? resource allocation normally doesn't block. So if there's
a ordering issue one of them will fail and should bail out.

That said if you have conflicting resources then failing is the correct
behavior anyways.

-Andi
