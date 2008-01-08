Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYAHX0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYAHX0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYAHX0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:26:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33320 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYAHX0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:26:14 -0500
Date: Wed, 9 Jan 2008 00:28:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, ananth@in.ibm.com,
       akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, mhiramat@redhat.com, davem@davemloft.net,
       hskinnemoen@atmel.com
Subject: Re: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
Message-ID: <20080108232841.GD2117@one.firstfloor.org>
References: <20080108063334.GA29385@in.ibm.com> <p73zlvgowwn.fsf@bingen.suse.de> <1199833842.3914.33.camel@dyn9047018096.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199833842.3914.33.camel@dyn9047018096.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have no problem with that, but if we want to make it buildable as a
> module, the call to get_kprobe() needs to be replaced with some other
> gcc-inline-defeating mechanism, or we need to export get_probe().  I

It's still unclear where noinline does not work (do you have details on that? 
It sounds a little dubious) but there are lots of different other ways to prevent gcc 
from inlining anything.

e.g. you can use stdarg or computed goto or a variable length local array 


> much prefer the former, since get_kprobe() is a kprobes-internal
> function.
> 
> Anybody know an architecture-independent way (other than noinline, which
> doesn't always work) of making gcc decide not to inline a function?

Details?

> E.g., does taking (and using) the function's address do it?

No, that just creates another out of line copy.

-Andi
