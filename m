Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0BTJ3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 04:29:39 -0500
Received: from gir.skynet.ie ([193.1.99.77]:54802 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab0BTJ3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 04:29:37 -0500
Date: Sat, 20 Feb 2010 09:29:21 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 03/12] mm: Share the anon_vma ref counts between KSM
	and page migration
Message-ID: <20100220092921.GH1445@csn.ul.ie>
References: <1266516162-14154-1-git-send-email-mel@csn.ul.ie> <1266516162-14154-4-git-send-email-mel@csn.ul.ie> <4B7F05BA.4080903@redhat.com> <20100219215826.GF1445@csn.ul.ie> <4B7F29CD.1050703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B7F29CD.1050703@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 07:16:13PM -0500, Rik van Riel wrote:
> On 02/19/2010 04:58 PM, Mel Gorman wrote:
>
>> external_refcount is about as good as I can think of to explain what's
>> going on :/
>
> Sounds "good" to me.  Much better than giving the wrong
> impression that this is the only refcount for the anon_vma.
>

Have renamed it so. If/when this all gets merged, I'll look into what's
required to make this a "real" refcount rather than the existing locking
mechanism. I'm very wary though because even with your anon_vma changes to
avoid excessive sharing, a refcount in there that is used in all paths might
become a hotly contended cache line. i.e. it might look nice, but it might
be a performance hit. It needs to be done carefully and as a separate
series.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
