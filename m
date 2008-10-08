Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYJHGwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYJHGwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYJHGwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:52:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32995 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYJHGwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:52:41 -0400
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
	arch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <6.0.0.20.2.20081008132532.056cc400@172.19.0.2>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2>
	 <20081007105056.16d9e785.akpm@linux-foundation.org>
	 <1223405963.26330.83.camel@lappy.programming.kicks-ass.net>
	 <200810081335.44576.nickpiggin@yahoo.com.au>
	 <6.0.0.20.2.20081008132532.056cc400@172.19.0.2>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 08:51:51 +0200
Message-Id: <1223448711.1378.16.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 13:48 +0900, Hisashi Hifumi wrote:

> Simultaneous access by two or more writer can corrupt file content,
> so this case needs some locks(flock or fcntl) to preserve synchronization
> of file content. This is responsibility of user-space application.
> But file->f_pos race issue can occur even if multiple threads just read 
> simultaneously. I think this is not responsibility of user-space application. 
> To avoid this currently, an application needs some locks to protect file offset
> even if it just read a file. So I think f_pos race should be fixed.

Just to add to all those who already said you're wrong :-)

You're wrong, if two threads would like to read the same file they
either dup() the fd or open() the file twice. There is absolutely no
valid reason to have two threads read from the same fd without
synchronising their access to it - never.

