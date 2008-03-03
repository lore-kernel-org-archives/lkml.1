Return-Path: <linux-kernel-owner+w=401wt.eu-S1758313AbYCCSmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbYCCSmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759388AbYCCSmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:42:01 -0500
Received: from smtp-out.google.com ([216.239.45.13]:1603 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180AbYCCSmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:42:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=wYJY9vo22Dn5JPdzfzGFDrTW2WG/jDSvKck6zLD6F1f16MI6AATfZHwM11BL8APec
	TOFiE1z0WaHYyMjQVXp6A==
Message-ID: <6599ad830803031041r6c635141n6520a915f2e1d08@mail.gmail.com>
Date: Mon, 3 Mar 2008 10:41:51 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, maxk@qualcomm.com,
       mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
In-Reply-To: <20080303121033.c8c9651c.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080227222103.673194000@chello.nl>
	 <1204311351.6243.130.camel@lappy> <20080229190223.GA17820@elte.hu>
	 <47C87084.3090208@qualcomm.com> <1204318980.6243.133.camel@lappy>
	 <47C8771C.1070001@qualcomm.com> <1204545445.11412.6.camel@twins>
	 <20080303113621.1dfdda87.pj@sgi.com> <1204567052.6241.4.camel@lappy>
	 <20080303121033.c8c9651c.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 10:10 AM, Paul Jackson <pj@sgi.com> wrote:
>   2) They need non-overlapping cpusets at this level to control
>     memory placement of some kernel allocations, which are allowed
>     outside the current tasks cpuset, to be confined by the nearest
>     ancestor cpuset marked 'mem_exclusive'

A while ago I posted a patch that split "cpusets" into "cpusets"
(controlling CPU) and "memsets" (controlling memory node placement).
It got luke-warm reception at the time, but maybe it's worth me fixing
it up and resending? It wouldn't have to affect the legacy mounts of
cpusets, but would allow memory and CPU assignments to be controlled
independently.

Also, one of the problems with the mem_exclusive flag at the moment is
that it's overloaded to mean "no-overlapping" and "no GFP_KERNEL
allocations outside this cpuset". If we added a "mem_hardwall" flag
that just had the latter semantics (i.e. either mem_exclusive or
mem_hardwall would be sufficient to confine GFP_KERNEL allocations
within the cpuset), you could have the confinement without worrying
about overlap issues.

Paul
