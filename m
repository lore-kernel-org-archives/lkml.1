Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYJQCdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYJQCdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 22:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYJQCdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 22:33:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53978
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbYJQCde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 22:33:34 -0400
Date: Thu, 16 Oct 2008 19:33:11 -0700 (PDT)
Message-Id: <20081016.193310.47274971.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: paulus@samba.org, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       benh@kernel.crashing.org, mingo@redhat.com
Subject: Re: [RFC patch 04/15] get_cycles() : powerpc64 HAVE_GET_CYCLES
 (update)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081017020813.GA32468@Krystal>
References: <20081017004328.GA29768@Krystal>
	<20081016.184252.193691889.davem@davemloft.net>
	<20081017020813.GA32468@Krystal>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Thu, 16 Oct 2008 22:08:13 -0400

> * David Miller (davem@davemloft.net) wrote:
> > Date: Thu, 16 Oct 2008 20:43:28 -0400
> > 
> > You'll need to make a similar fix on sparc64.
> 
> I guess you are talking about using sparc64_get_clock_tick rather than
> CLOCK_TICK_RATE ? I assume sparc64_get_clock_tick() done on any CPU will
> return the same rate ?

You'll need to use tb_ticks_per_usec or similar.

The ->get_tick() thing you are using uses a TICK source which is
synchronized across the entire system and advances at a non-changing
rate.

sparc64_get_clock_tick() returns something different.
