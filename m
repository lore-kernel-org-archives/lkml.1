Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbXHOETE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbXHOETE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 00:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbXHOESw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 00:18:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55488 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbXHOESv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 00:18:51 -0400
Date: Wed, 15 Aug 2007 05:18:45 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rddunlap@osdl.org>, Martin Bligh <mbligh@google.com>
Subject: Re: [patch 2/2] Sort module list by pointer address to get coherent sleepable seq_file iterators
Message-ID: <20070815041845.GJ21089@ftp.linux.org.uk>
References: <20070812150844.305211039@polymtl.ca> <20070812151039.996081605@polymtl.ca> <20070815033945.GA13134@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815033945.GA13134@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 11:39:45AM +0800, Fengguang Wu wrote:
> On Sun, Aug 12, 2007 at 11:08:46AM -0400, Mathieu Desnoyers wrote:
> >  
> >  static void *m_next(struct seq_file *m, void *p, loff_t *pos)
> >  {
> > -	return seq_list_next(p, &modules, pos);
> > +	return seq_sorted_list_next(p, &modules, &m->private);
> >  }
> 
> In theory it is not safe to use something other than the passed in
> *pos as an position indicator. Because seq_file do not always call
> ->next() to advance to the next item. Look at seq_file.c, it sometimes
> increase the pos/index directly! Which also prevents pos to skip
> forward, which is preferred in your case.
> 
> The attached patch tries to fix it.
> 
> The seq_file.c is so twisted!
> 
> Fengguang
> ===
> 
> seqfile: remove seq_file's assumption about iterators
> 
> The seq_file implementation has some hardcoded index++/pos++ lines,
> which assumes iterators to be *continuous* integers.

What the fuck?  It assumes no such thing and a lot of iterators are
nothing like integers.  What are you talking about?
