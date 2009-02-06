Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbZBFH3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbZBFH3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZBFH3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:29:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42243 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZBFH3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:29:15 -0500
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Campbell <ian.campbell@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org,
       Ravikiran Thirumalai <kiran@scalemp.com>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 5 of 7] x86/paravirt: add register-saving thunks to reduce caller register pressure
From: Andi Kleen <andi@firstfloor.org>
References: <patchbomb.1233182100@abulafia.goop.org>
	<7d4a052c499dbfe5e816.1233182105@abulafia.goop.org>
Date: Fri, 06 Feb 2009 08:28:26 +0100
In-Reply-To: <7d4a052c499dbfe5e816.1233182105@abulafia.goop.org> (Jeremy Fitzhardinge's message of "Wed, 28 Jan 2009 14:35:05 -0800")
Message-ID: <87fxisvxb9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> One of the problems with inserting a pile of C calls where previously
> there were none is that the register pressure is greatly increased.
> The C calling convention says that the caller must expect a certain
> set of registers may be trashed by the callee, and that the callee can
> use those registers without restriction.  This includes the function
> argument registers, and several others.
>
> This patch seeks to alleviate this pressure by introducing wrapper
> thunks that will do the register saving/restoring, so that the
> callsite doesn't need to worry about it, but the callee function can
> be conventional compiler-generated code. 

I had something like this (but not as generic) for the old pre
unification semaphores on x86-64 too. I think it's a generally useful
facility for lots of things (in fact I've been asking gcc developers
for providing this in a general way for some time).

So I would suggest to move the necessary macros to do that outside
paravirt.h into a separate include so that it can be used independently
and not call it PV_*.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
