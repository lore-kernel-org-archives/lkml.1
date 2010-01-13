Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686Ab0AMXwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0AMXwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235Ab0AMXwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:52:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53100 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab0AMXwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:52:15 -0500
Date: Thu, 14 Jan 2010 00:52:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as
	hotplug cpus.
Message-ID: <20100113235214.GG24818@basil.fritz.box>
References: <4B4D0E39.10200@kernel.org> <87tyupfzk8.fsf@basil.nowhere.org> <4B4E427D.9090207@zytor.com> <20100113222348.GE24818@basil.fritz.box> <4B4E48BB.5030902@zytor.com> <1263421753.2865.103.camel@sbs-t61.sc.intel.com> <4B4E4AE3.1030608@zytor.com> <1263422958.2865.107.camel@sbs-t61.sc.intel.com> <4B4E511C.1050609@kernel.org> <4B4E5390.1070004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4E5390.1070004@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just built an allyesconfig kernel, and it has 1904K of percpu data.
> 1791K of that is in per_cpu__cpu_lock_stats.  So everything else is

Ok so we need to fix lock stats, I'll put it on my todo list.

> ~113K.  Still.  We should not be restricted from doing legitimately
> large percpu allocations because of ghost cpus (and Tejun knows my
> position on this), but it doesn't sound like the house is burning, either.

I think it's legitimate to require explicit allocation on
add/remove event for anything large.

Static per cpu is really only for "lazy users" anyways.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
