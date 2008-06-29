Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbYF2Ouh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbYF2Ouh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 10:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbYF2Ou3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 10:50:29 -0400
Received: from [194.117.236.238] ([194.117.236.238]:51132 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbYF2Ou2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 10:50:28 -0400
Date: Sun, 29 Jun 2008 17:43:02 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <srostedt@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: -tip: WARNING: at kernel/lockdep.c:2738
Message-ID: <20080629174302.6d5d0797@linux360.ro>
In-Reply-To: <19f34abd0806290651g15d3048ejf41f0bd9f7ec1d4d@mail.gmail.com>
References: <19f34abd0806290532k1b176d97k96f7c5bb2bb9e830@mail.gmail.com>
	<20080629130554.GA16703@elte.hu>
	<19f34abd0806290651g15d3048ejf41f0bd9f7ec1d4d@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 15:51:33 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:
 
> Yep, thanks, that gets rid of it for me! Although I'm not sure how
> reproducible it was in the first place.
> 
> 
> Vegard
> 

lockdep's warnings are very reproducible as long as that code runs at
least once and that specific state transition occurs. AFAICS, all you
need to do is make sure cpu_clock() is called at least once with IRQs on
and at least once with IRQs off (this covers all possible cases). The
first case (IRQs on) is the important one and the one that produced the
bug, IMO.

The problem was raw_local_irq_save() does not record transitions, which
misleads lockdep. This likely wasn't a real bug.


	Eduard
