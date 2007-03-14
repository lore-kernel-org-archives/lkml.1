Return-Path: <linux-kernel-owner+w=401wt.eu-S1161323AbXCNPE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161323AbXCNPE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161328AbXCNPE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:04:26 -0400
Received: from holomorphy.com ([66.93.40.71]:34592 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161323AbXCNPE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:04:26 -0400
Date: Wed, 14 Mar 2007 08:03:06 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelianov <xemul@sw.ru>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [RFC] kernel/pid.c pid allocation wierdness
Message-ID: <20070314150306.GT2986@holomorphy.com>
References: <45F7A4B3.5040005@sw.ru> <m16493rk18.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m16493rk18.fsf@ebiederm.dsl.xmission.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 08:12:35AM -0600, Eric W. Biederman wrote:
> If we do dig into this more we need to consider a radix_tree to hold
> the pid values.  That could replace both the pid map and the hash
> table, gracefully handle but large and small pid counts, might
> be a smidgin simpler, possibly be more space efficient, and it would
> more easily handle multiple pid namespaces.   The downside to using a
> radix tree is that is looks like it will have more cache misses for
> the normal pid map size, and it is yet another change that we would
> need to validate.

Radix trees' space behavior is extremely poor in sparsely-populated
index spaces. There is no way they would save space or even come close
to the current space footprint.

Lock contention here would be a severe functional regression (note
"functional," not "performance;" the lock contention surrounding these
affairs takes down systems vs. mere slowdown nonsense), so it would
necessarily depend on lockless radix tree code for correctness.

The comment block describing the hashtable locking is stale and should
have been updated in tandem with the RCU changes.


-- wli
