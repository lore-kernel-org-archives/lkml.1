Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYJQPjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYJQPjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbYJQPjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:39:43 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49377 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbYJQPjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:39:41 -0400
Subject: Re: [PATCH 5/9] Restore memory address space
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Linus Torvalds <torvalds@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1224233070.2634.114.camel@frecb000730.frec.bull.fr>
References: <20081016181414.934C4FCC@kernel>
	 <20081016181421.3BA319FA@kernel>
	 <1224233070.2634.114.camel@frecb000730.frec.bull.fr>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 08:39:34 -0700
Message-Id: <1224257974.1848.49.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 10:44 +0200, Nadia Derbey wrote:
> On Thu, 2008-10-16 at 11:14 -0700, Dave Hansen wrote:
> > +static int cr_page_read(struct cr_ctx *ctx, struct page *page, char *buf)
> > +{
> > +	void *ptr;
> > +	int ret;
> > +
> > +	ret = cr_kread(ctx, buf, PAGE_SIZE);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ptr = kmap_atomic(page, KM_USER1);
> > +	memcpy(ptr, buf, PAGE_SIZE);
> > +	kunmap_atomic(page, KM_USER1);
> 
> Here too, I think this should be changed to 
> kunmap_atomic(ptr, KM_USER1);

Thanks, Nadia.

These fixes will show up in the git tree shortly:

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/daveh/linux-2.6-cr.git;a=summary

I just created it, so it may take a few moments for the gitweb script to
find it.

-- Dave

