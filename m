Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbZE0Aaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbZE0Aaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbZE0Aac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:30:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204AbZE0Aab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:30:31 -0400
Date: Tue, 26 May 2009 17:29:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-Id: <20090526172935.fad52c49.akpm@linux-foundation.org>
In-Reply-To: <20090527001104.GN846@one.firstfloor.org>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com>
	<878wkjobbm.fsf@basil.nowhere.org>
	<20090526160017.98fc62e4.akpm@linux-foundation.org>
	<20090526231428.GK846@one.firstfloor.org>
	<20090526162821.02e11d5b.akpm@linux-foundation.org>
	<20090526234109.GL846@one.firstfloor.org>
	<20090526164532.6c780234.akpm@linux-foundation.org>
	<20090527001104.GN846@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 02:11:04 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> > I dunno.  Is this true of all linux filesystems in all cases?  Maybe.
> 
> Assuming one of them is not would you rather want to fix that file system
> or 10 zillion user programs (including the kernel core dumper) that 
> get it wrong? @)
> 

I think that removing one bug is better than adding one.

Many filesystems will return a short write if they hit a memory
allocation failure, for example.  pipe_write() sure will.  Retrying
is appropriate in such a case.

