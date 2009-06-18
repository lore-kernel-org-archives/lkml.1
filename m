Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZFRVXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZFRVXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZFRVXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:23:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbZFRVXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:23:43 -0400
Date: Thu, 18 Jun 2009 14:22:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kyle@mcmartin.ca
Subject: Re: [GIT PULL] percpu for 2.6.31
In-Reply-To: <4A39F5B4.1070305@kernel.org>
Message-ID: <alpine.LFD.2.01.0906181421460.16802@localhost.localdomain>
References: <4A39F5B4.1070305@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Jun 2009, Tejun Heo wrote:
> 
> Please pull from percpu-for-linus git tree from:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

I'm very unhappy with this kind of crap.

Has it been tested AT ALL? Apparently not.

	arch/x86/kernel/cpu/mcheck/mce.c:98: error: multiple storage classes in declaration specifiers
	arch/x86/kernel/cpu/mcheck/mce.c:98: error: non-static declaration of ¡per_cpu__mces_seen¢ follows static declaration
	arch/x86/kernel/cpu/mcheck/mce.c:98: note: previous declaration of ¡per_cpu__mces_seen¢ was here
	.. and tons of other similar errors ..

and it was apparently done on purpose, for no good reason. The bug with 
static per-cpu variables is only for some broken architectures.

Even the _documentation_ uses "static DEFINE_PER_CPU(..)" for chissake!

To make matters worse, this whole series was clearly rebased (or applied 
from some other queue) just _minutes_ before sending it to me. No wonder 
it had zero testing:

 - commit:
	Date: Thu Jun 18 16:22:05 2009 +0900
 - email:
	Date: Thu, 18 Jun 2009 17:07:16 +0900

I'm not pulling it. Or rather, I pulled it, ended up doing other work, 
noticed the problems, and had to re-do my whole tree because I refuse to 
have sh*t like this in the kernel.

And I'm not going to pull trees that get rebased like this with basically 
no testing before sending it to me. There's a reason I don't like 
rebasing.

			Linus
