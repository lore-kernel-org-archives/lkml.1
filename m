Return-Path: <linux-kernel-owner+w=401wt.eu-S965344AbXAYFmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965344AbXAYFmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 00:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXAYFmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 00:42:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44645 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965344AbXAYFmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 00:42:46 -0500
Date: Thu, 25 Jan 2007 05:42:42 +0000
From: Christoph Hellwig <hch@infradead.org>
To: S?bastien Dugu? <sebastien.dugue@bull.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH -mm 4/5][AIO] - AIO completion signal notification
Message-ID: <20070125054242.GA8799@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	S?bastien Dugu? <sebastien.dugue@bull.net>,
	Andrew Morton <akpm@osdl.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Ulrich Drepper <drepper@redhat.com>,
	Zach Brown <zach.brown@oracle.com>,
	Jean Pierre Dion <jean-pierre.dion@bull.net>,
	Badari Pulavarty <pbadari@us.ibm.com>
References: <20070117104601.36b2ab18@frecb000686> <20070117105018.7213ed7c@frecb000686> <20070123213513.2454b24d.akpm@osdl.org> <20070124121130.0dfc8573@frecb000686>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124121130.0dfc8573@frecb000686>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 12:11:30PM +0100, S?bastien Dugu? wrote:
> > > +	if (unlikely(!notify->sigq))
> > > +		return -EAGAIN;
> > 
> > Did this just leak a ref on the task_struct?
> > 
> 
>   No, the ref is released in really_put_req() when we dispose of
> the iocb.

And the code really needs a comment explaining this.  I tripped over
this before, and I think it's even already the second time Andrew
stumbled over it.

