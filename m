Return-Path: <linux-kernel-owner+w=401wt.eu-S1751775AbZIYEVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbZIYEVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 00:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZIYEVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 00:21:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbZIYEVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 00:21:21 -0400
Date: Thu, 24 Sep 2009 21:20:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/12] Immediate Values - Architecture Independent Code
Message-Id: <20090924212013.d27226c4.akpm@linux-foundation.org>
In-Reply-To: <20090924133359.218934235@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
	<20090924133359.218934235@polymtl.ca>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 09:26:28 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Immediate values are used as read mostly variables that are rarely updated. They
> use code patching to modify the values inscribed in the instruction stream. It
> provides a way to save precious cache lines that would otherwise have to be used
> by these variables.

What a hare-brained concept.

> * Why should this be merged *
> 
> It improves performances on heavy memory I/O workloads.
> 
> An interesting result shows the potential this infrastructure has by
> showing the slowdown a simple system call such as getppid() suffers when it is
> used under heavy user-space cache trashing:
> 
> Random walk L1 and L2 trashing surrounding a getppid() call:
> (note: in this test, do_syscal_trace was taken at each system call, see
> Documentation/immediate.txt in these patches for details)
> - No memory pressure :   getppid() takes  1573 cycles
> - With memory pressure : getppid() takes 15589 cycles

Our ideas of what constitutes an "interesting result" differ.

Do you have any data which indicates that this thing is of any real
benefit to anyone for anything?
