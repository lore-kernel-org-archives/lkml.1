Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZCLUZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZCLUZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZCLUY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:24:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206AbZCLUY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:24:57 -0400
Date: Thu, 12 Mar 2009 13:21:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: jmoyer@redhat.com, avi@redhat.com, linux-aio@kvack.org,
       zach.brown@oracle.com, bcrl@kvack.org, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org, cl@linux-foundation.org
Subject: Re: [PATCH] fs: fput() can be called from interrupt context
Message-Id: <20090312132115.21b478cd.akpm@linux-foundation.org>
In-Reply-To: <49B960DE.6000406@cosmosbay.com>
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
	<49B54143.1010607@redhat.com>
	<x49sklmd1fo.fsf@segfault.boston.devel.redhat.com>
	<49B57CB0.5020300@cosmosbay.com>
	<49B875F7.3030305@cosmosbay.com>
	<49B87CFE.4000701@cosmosbay.com>
	<49B89B22.7080303@cosmosbay.com>
	<20090311224712.fb8db075.akpm@linux-foundation.org>
	<49B8A75E.6040409@cosmosbay.com>
	<20090311233903.f036027a.akpm@linux-foundation.org>
	<49B960DE.6000406@cosmosbay.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 20:22:06 +0100
Eric Dumazet <dada1@cosmosbay.com> wrote:

> > It's somewhat encouraging that we're apparently already doing fput()
> > from within keventd (although how frequently?).  There might be
> > problems with file locking, security code, etc from doing fput() from
> > an unexpected thread.  And then there are all the usual weird problem
> > with using the keventd queues which take a long time to get discovered.
> > 
> 
> Hum... Do you mean "if (in_interrupt())" is not the right test to
> perform ? 

No, in_interrupt() seems appropriate.

It's a bit weak, because it means that the proposed code can't be used
for calling fput() inside spinlock.  A better interface would be to
add a new fput_atomic() and let the caller decide which functions
should be called, depending upon what context the caller is running in.



