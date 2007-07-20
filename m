Return-Path: <linux-kernel-owner+w=401wt.eu-S934139AbXGTVNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139AbXGTVNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbXGTVNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:13:44 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48690 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbXGTVNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:13:42 -0400
Subject: Re: [PATCH] hugetlbfs read() support
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bill Irwin <bill.irwin@oracle.com>, nacc@us.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <46A03A17.8090708@yahoo.com.au>
References: <1184376214.15968.9.camel@dyn9047017100.beaverton.ibm.com>
	 <20070718221950.35bbdb76.akpm@linux-foundation.org>
	 <1184860309.18188.90.camel@dyn9047017100.beaverton.ibm.com>
	 <20070719095850.6e09b0e8.akpm@linux-foundation.org>
	 <46A03A17.8090708@yahoo.com.au>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 14:15:33 -0700
Message-Id: <1184966133.21127.0.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 14:29 +1000, Nick Piggin wrote:
> Andrew Morton wrote:
> > On Thu, 19 Jul 2007 08:51:49 -0700 Badari Pulavarty <pbadari@us.ibm.com> wrote:
> > 
> > 
> >>>>+		}
> >>>>+
> >>>>+		offset += ret;
> >>>>+		retval += ret;
> >>>>+		len -= ret;
> >>>>+		index += offset >> HPAGE_SHIFT;
> >>>>+		offset &= ~HPAGE_MASK;
> >>>>+
> >>>>+		page_cache_release(page);
> >>>>+		if (ret == nr && len)
> >>>>+			continue;
> >>>>+		goto out;
> >>>>+	}
> >>>>+out:
> >>>>+	return retval;
> >>>>+}
> >>>
> >>>This code doesn't have all the ghastly tricks which we deploy to handle
> >>>concurrent truncate.
> >>
> >>Do I need to ? Baaahh!!  I don't want to deal with them. 
> > 
> > 
> > Nick, can you think of any serious consequences of a read/truncate race in
> > there?  I can't..
> 
> As it doesn't allow writes, then I _think_ it should be OK. If you
> ever did want to add write(2) support, then you would have transient
> zeroes problems.

I have no plans to add write() support - unless there is real reason
for doing so.

> 
> But why not just hold i_mutex around the whole thing just to be safe?

Yeah. I can do that, just to be safe for future..

Thanks,
Badari

