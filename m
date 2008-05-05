Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbYEEUJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbYEEUJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760768AbYEEUJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:09:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760751AbYEEUJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:09:14 -0400
Date: Mon, 5 May 2008 13:09:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: + git-net-git-rejects.patch added to -mm tree
Message-Id: <20080505130911.52b22577.akpm@linux-foundation.org>
In-Reply-To: <20080505.125118.101401893.davem@davemloft.net>
References: <200805051905.m45J5eG7032280@imap1.linux-foundation.org>
	<20080505.125118.101401893.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2008 12:51:18 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: akpm@linux-foundation.org
> Date: Mon, 05 May 2008 12:05:40 -0700
> 
> > Subject: git-net-git-rejects
> > 
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> What happened here?

I'm still working out how to incorporate linux-next so I didn't really look
at the actual specfics of this problem.

I noticed that there were rather a lot of changes in
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
which are not in linux-next, perhaps due to time lag.

So I generated a diff between linux-next and net-2.6.git using my rather
wonky script to do that.  This script does tend to muck things up
sometimes.

Then on top of origin.patch, linux-next.patch, the above git-net.patch and
this fixup I generated git-net-next.patch from
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
and that appeared to apply cleanly.

It's all rather complex and I haven't yet got down to working out what's
actually happening.

> Did you apply Ingo's IRDA build fixup patches, like I did, and clean
> them up or change them in some way?

umm, let me see.

No, I think it's a genuine conflict.  linux-next has

commit 01c419104cca3d512a24e160447355487fcfe21c
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Mar 28 10:54:43 2008 -0600

    nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
    
and that conflicts with the irda changes in your tree.



I don't know how that patch got into linux-next.  I thought that Len merged
Bjorn's changes, but that patch doesn't have Len's signoff and that patch
doesn't appear in
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git#test

