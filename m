Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277Ab0ABBmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0ABBmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 20:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191Ab0ABBmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 20:42:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35890 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0ABBmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 20:42:52 -0500
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Stefani Seibold <stefani@seibold.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] proc: revert to show stack information in /proc/{pid}/status
From: Andi Kleen <andi@firstfloor.org>
References: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
	<1262274494.14143.7.camel@wall-e>
	<20100101155630.1A1E.A69D9226@jp.fujitsu.com>
	<1262358616.11460.18.camel@wall-e> <20100101220529.GL4620@const>
Date: Sat, 02 Jan 2010 02:42:48 +0100
In-Reply-To: <20100101220529.GL4620@const> (Samuel Thibault's message of "Fri, 1 Jan 2010 23:05:29 +0100")
Message-ID: <87k4w1704n.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault <samuel.thibault@ens-lyon.org> writes:

> Stefani Seibold, le Fri 01 Jan 2010 16:10:16 +0100, a écrit :
>> But ps is not a performance critical application nor a cat
>> /proc/*/status!
>
> Errr, maybe not so much as some other operations, but a lot of tools use
> them, so it's really worth considering it.

As an historical anecdote one of my first patches to Linux ever made
exactly the same mistake as Stefani's (adding mmap_sem to a proc file
read by proc). It was quickly reverted again by Linus when the
reports of ps not working under swapping poured in.

Same should be done with this patch (commit 9ebd4eba761b624a6a6c9189335adeddcb1fa0e0)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
