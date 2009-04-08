Return-Path: <linux-kernel-owner+w=401wt.eu-S1763312AbZDHJrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763312AbZDHJrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbZDHJrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:47:23 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:20104 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbZDHJrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:47:22 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [BUG 2.6.29] NMI watchdog triggered in rb_insert_color called
 from enqueue_hrtimer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <20090408092452.GA26121@elte.hu>
References: <18908.27242.966881.409415@pilspetsen.it.uu.se>
	 <20090408092452.GA26121@elte.hu>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 11:49:05 +0200
Message-Id: <1239184146.24828.1366.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 11:24 +0200, Ingo Molnar wrote:
> * Mikael Pettersson <mikpe@it.uu.se> wrote:
> 
> > Less than an hour after updating a dual Opteron 8384 box from 
> > 2.6.29-rc6 (which it had been running for weeks) to 2.6.29 final 
> > it died with the following watchdog-detected lockup:
> 
> Could you please check whether this is the bug fixed by:
> 
>   7f1e2ca: hrtimer: fix rq->lock inversion (again)

Doesn't look like rq->lock recursion, but its worth a try.

Also, hrtimer_wakeup() isn't a self-rearming timer, so its unlikely to
get stuck in a loop, oddness.

