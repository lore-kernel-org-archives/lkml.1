Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXCKLZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXCKLZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 07:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbXCKLZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 07:25:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45871 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbXCKLZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 07:25:18 -0400
Subject: Re: [PATCH 3/7] revoke: core code
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
In-Reply-To: <1173443414.4429.7.camel@lappy>
References: <Pine.LNX.4.64.0703091014450.32320@sbz-30.cs.Helsinki.FI>
	 <1173443414.4429.7.camel@lappy>
Date: Sun, 11 Mar 2007 13:25:16 +0200
Message-Id: <1173612316.7330.3.camel@haji>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 10:15 +0200, Pekka J Enberg wrote:
> > +  again:
> > +	restart_addr = zap_page_range(vma, start_addr, end_addr - start_addr,
> > +				      details);
> > +
> > +	need_break = need_resched() || need_lockbreak(details->i_mmap_lock);
> > +	if (need_break)
> > +		goto out_need_break;
> > +
> > +	if (restart_addr < end_addr) {
> > +		start_addr = restart_addr;
> > +		goto again;
> > +	}
> > +	return 0;
> > +
> > +  out_need_break:
> > +	spin_unlock(details->i_mmap_lock);
> > +	cond_resched();
> > +	spin_lock(details->i_mmap_lock);
> > +	return -EINTR;

On Fri, 2007-03-09 at 13:30 +0100, Peter Zijlstra wrote:
> I'm not sure this scheme works, given a sufficiently loaded machine,
> this might never complete.

Hmm, so what's the alternative? It's better to fail revoke than lock up
the box.

On Fri, 2007-03-09 at 13:30 +0100, Peter Zijlstra wrote:
> I'm never sure of operator precedence and prefer:
> 
>  (vma->vm_flags & VM_SHARED) && ...
> 
> which leaves no room for error.

Thanks, fixed.

