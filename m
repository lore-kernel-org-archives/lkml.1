Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbZD2F6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbZD2F6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZD2F6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:58:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbZD2F6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:58:08 -0400
Date: Tue, 28 Apr 2009 22:55:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] ring-buffer: fix printk output
Message-Id: <20090428225541.9ca61a12.akpm@linux-foundation.org>
In-Reply-To: <20090429054359.GA6148@elte.hu>
References: <20090429044814.138790038@goodmis.org>
	<20090429045908.394874083@goodmis.org>
	<20090428222024.8db50539.akpm@linux-foundation.org>
	<20090429054359.GA6148@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 07:43:59 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 29 Apr 2009 00:48:19 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > -	printk_once(KERN_WARNING "Tracing recursion: depth[%d]:"
> > > +	printk_once(KERN_WARNING "Tracing recursion: depth[%ld]:"
> > 
> > hrmph.  I didn't know that printk_once() existed, and I should 
> > have known.  I wonder how many other people don't know.
> 
> Was posted to linux-next@vger.kernel.org.

Well no wonder I didn't know about it.

> > Should it use unlikely()?
> 
> Not really. Any printk_once() usage site is an 'unlikely' branch 
> already in most cases. Double unlikely just spreads the instructions 
> needlessly. The condition that _leads_ to a printk_once() should be 
> an unlikely().
> 

OK.
