Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbXGWOTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbXGWOTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbXGWOTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:19:12 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46573 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbXGWOTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:19:11 -0400
Date: Mon, 23 Jul 2007 07:02:24 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Bill Irwin <bill.irwin@oracle.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] hugetlbfs read() support
Message-ID: <20070723140224.GC23148@us.ibm.com>
References: <1184376214.15968.9.camel@dyn9047017100.beaverton.ibm.com> <20070718221950.35bbdb76.akpm@linux-foundation.org> <1184860309.18188.90.camel@dyn9047017100.beaverton.ibm.com> <20070719095850.6e09b0e8.akpm@linux-foundation.org> <20070719170759.GE2083@us.ibm.com> <46A03E63.2080508@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A03E63.2080508@yahoo.com.au>
X-Operating-System: Linux 2.6.22-rc6-gaee87db2 (x86_64)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.07.2007 [14:47:31 +1000], Nick Piggin wrote:
> Nishanth Aravamudan wrote:
> >On 19.07.2007 [09:58:50 -0700], Andrew Morton wrote:
> >
> >>On Thu, 19 Jul 2007 08:51:49 -0700 Badari Pulavarty <pbadari@us.ibm.com> 
> >>wrote:
> >>
> >>
> >>>>>+		}
> >>>>>+
> >>>>>+		offset += ret;
> >>>>>+		retval += ret;
> >>>>>+		len -= ret;
> >>>>>+		index += offset >> HPAGE_SHIFT;
> >>>>>+		offset &= ~HPAGE_MASK;
> >>>>>+
> >>>>>+		page_cache_release(page);
> >>>>>+		if (ret == nr && len)
> >>>>>+			continue;
> >>>>>+		goto out;
> >>>>>+	}
> >>>>>+out:
> >>>>>+	return retval;
> >>>>>+}
> >>>>
> >>>>This code doesn't have all the ghastly tricks which we deploy to
> >>>>handle concurrent truncate.
> >>>
> >>>Do I need to ? Baaahh!!  I don't want to deal with them. 
> >>
> >>Nick, can you think of any serious consequences of a read/truncate
> >>race in there?  I can't..
> >>
> >>
> >>>All I want is a simple read() to get my oprofile working.  Please
> >>>advise.
> >>
> >>Did you consider changing oprofile userspace to read the executable
> >>with mmap?
> >
> >
> >It's not actually oprofile's code, though, it's libbfd (used by
> >oprofile). And it works fine (presumably) for other binaries.
> 
> So... what's the problem with changing it? The fact that it is a
> library doesn't really make a difference except that you'll also help
> everyone else who links with it.

Well, I'm more concerned about testing that change libbfd is rather core
code and used in a number of places. Also, libbfd's current code 'just
works' for every other filesystem concerned, or I'd expect it would have
been changed to mmap() before. I'm also terrified of binutils code :)
I'm also not sure who I'm 'helping', exactly by changing it, beyond
users of libhugetlbfs and OProfile, who are equally helped by this
kernel patch (which, again, also has the added benefit of making
hugetlbfs appear to be more like a normal filesystem).

> It won't break backwards compatibility, and it will work on older
> kernels...

Fair enough. I'm looking into it, but I can't make any promises on
timelines.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
