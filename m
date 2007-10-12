Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbXJLUBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbXJLUBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 16:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbXJLUBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 16:01:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754378AbXJLUBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 16:01:33 -0400
Date: Fri, 12 Oct 2007 13:01:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: viro@ftp.linux.org.uk, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, sam@ravnborg.org, netdev@vger.kernel.org
Subject: Re: 2.6.23-mm1 thread exit_group issue
Message-Id: <20071012130107.6f1c8421.akpm@linux-foundation.org>
In-Reply-To: <20071012194759.GA31733@Krystal>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com>
	<20071011234202.2f15bb76.akpm@linux-foundation.org>
	<20071012064658.GA8181@ftp.linux.org.uk>
	<20071012001325.ba02a6f0.akpm@linux-foundation.org>
	<20071012194759.GA31733@Krystal>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 15:47:59 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> I noticed a regression between 2.6.23-rc8-mm2 and 2.6.23-mm1 (with your
> hotfixes). User space threads seems to receive a ERESTART_RESTARTBLOCK
> as soon as a thread does a pthread_join on them. The previous behavior
> was to wait for them to exit by taking a futex.
> 
> I provide a toy program that shows the problem. On 2.6.23-rc8-mm2, it
> loops forever (as it should). On 2.6.23-mm1, it exits after 10 seconds.
> 
> Any idea on what may cause this problem ?
> 
> (I also provide complete ptrace -f of a correct and buggy run and my
> kernel config. Tests were done on i386.)

No idea.  But I can reproduce it here so I'll bisect it now.  Thanks
for the test case!
