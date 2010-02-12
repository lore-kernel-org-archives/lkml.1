Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab0BLSjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 13:39:11 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56233 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab0BLSjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 13:39:09 -0500
Date: Fri, 12 Feb 2010 18:38:54 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Valdis.Kletnieks@vt.edu
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/12] Add /proc trigger for memory compaction
Message-ID: <20100212183854.GB23822@csn.ul.ie>
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie> <1265976059-7459-7-git-send-email-mel@csn.ul.ie> <7691.1265999680@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <7691.1265999680@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 01:34:40PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 12 Feb 2010 12:00:53 GMT, Mel Gorman said:
> > This patch adds a proc file /proc/sys/vm/compact_memory. When an arbitrary
> > value is written to the file, all zones are compacted. The expected user
> > of such a trigger is a job scheduler that prepares the system before the
> > target application runs.
> 
> Argh. A global trigger in /proc, and a per-node trigger in /sys too.  Can we
> get by with just one or the other?  Should the /proc one live in /sys too?
> 

The sysfs trigger is only visible on NUMA. The proc one is easier to use
when the requirement is "compact all memory". There doesn't appear to be a
suitable place in sysfs for the proc trigger as it's already the case that
all proc tunables are not reflected in sysfs.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
