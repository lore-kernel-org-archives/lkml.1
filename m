Return-Path: <linux-kernel-owner+w=401wt.eu-S940113AbXGSQ7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940113AbXGSQ7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbXGSQ7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:59:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33638 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754783AbXGSQ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:59:21 -0400
Date: Thu, 19 Jul 2007 09:58:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Bill Irwin <bill.irwin@oracle.com>, nacc@us.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] hugetlbfs read() support
Message-Id: <20070719095850.6e09b0e8.akpm@linux-foundation.org>
In-Reply-To: <1184860309.18188.90.camel@dyn9047017100.beaverton.ibm.com>
References: <1184376214.15968.9.camel@dyn9047017100.beaverton.ibm.com>
	<20070718221950.35bbdb76.akpm@linux-foundation.org>
	<1184860309.18188.90.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 08:51:49 -0700 Badari Pulavarty <pbadari@us.ibm.com> wrote:

> > > +		}
> > > +
> > > +		offset += ret;
> > > +		retval += ret;
> > > +		len -= ret;
> > > +		index += offset >> HPAGE_SHIFT;
> > > +		offset &= ~HPAGE_MASK;
> > > +
> > > +		page_cache_release(page);
> > > +		if (ret == nr && len)
> > > +			continue;
> > > +		goto out;
> > > +	}
> > > +out:
> > > +	return retval;
> > > +}
> > 
> > This code doesn't have all the ghastly tricks which we deploy to handle
> > concurrent truncate.
> 
> Do I need to ? Baaahh!!  I don't want to deal with them. 

Nick, can you think of any serious consequences of a read/truncate race in
there?  I can't..

> All I want is a simple read() to get my oprofile working.
> Please advise.

Did you consider changing oprofile userspace to read the executable with
mmap?
