Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbXFVQfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbXFVQfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbXFVQfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:35:37 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:62162 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416AbXFVQfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:35:36 -0400
Message-ID: <467BFA47.4050802@linux.vnet.ibm.com>
Date: Fri, 22 Jun 2007 22:05:19 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-mm <linux-mm@kvack.org>, Balbir Singh <balbir@in.ibm.com>,
       Pavel Emelianov <xemul@sw.ru>, Paul Menage <menage@google.com>,
       Kirill Korotaev <dev@sw.ru>, devel@openvz.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Roy Huang <royhuang9@gmail.com>,
       Aubrey Li <aubreylee@gmail.com>
Subject: Re: [RFC] mm-controller
References: <1182418364.21117.134.camel@twins> <467A5B1F.5080204@linux.vnet.ibm.com> <1182433855.21117.160.camel@twins>
In-Reply-To: <1182433855.21117.160.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Thu, 2007-06-21 at 16:33 +0530, Balbir Singh wrote:
>> Peter Zijlstra wrote:
[snip]

> Not quite sure on 2, from reading the pagecache controller, I got the
> impression that enforcing both limits got you into trouble. Merging the
> limits would rid us of that issue, no?
> 

Hi Peter,

Setting both limits in pagecache controller (v4) will work correct in
principle.  What I intended in the comment is performance issues and
wrong type of page being reclaimed.  We are working on the issues and
will fix them in future versions.  You can set any combination of
limits and the reclaim will work to keep the page utilization below
limits.

When RSS limit is hit, ANON pages are pushed to swapcache.  We would
need to limit swapcache (using pagecache_limit) to force a write out
to disk.

Merging both limits will eliminate the issue, however we would need
individual limits for pagecache and RSS for better control.  There are
use cases for pagecache_limit alone without RSS_limit like the case of
database application using direct IO, backup applications and
streaming applications that does not make good use of pagecache.

Thank you for the review and new design proposal.

--Vaidy

[snip]


