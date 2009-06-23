Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbZFWWXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbZFWWXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZFWWXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:23:41 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:58779 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741AbZFWWXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:23:40 -0400
Subject: Re: [PATCH] Hugepages should be accounted as unevictable pages.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Mel Gorman <mel@csn.ul.ie>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1245795352.17685.31312.camel@nimitz>
References: <20090623093459.2204.A69D9226@jp.fujitsu.com>
	 <1245732411.18339.6.camel@alok-dev1>
	 <20090623135017.220D.A69D9226@jp.fujitsu.com>
	 <20090623141147.8f2cef18.kamezawa.hiroyu@jp.fujitsu.com>
	 <1245736441.18339.21.camel@alok-dev1>  <4A41481D.1060607@redhat.com>
	 <1245793331.24110.33.camel@alok-dev1> <1245795352.17685.31312.camel@nimitz>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 23 Jun 2009 15:23:43 -0700
Message-Id: <1245795823.24110.48.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-06-23 at 15:15 -0700, Dave Hansen wrote:
> On Tue, 2009-06-23 at 14:42 -0700, Alok Kataria wrote:
> > One thing that i forgot to mention earlier is that, I just need a way to
> > provide a hint about the total locked memory  on the system and it
> > doesn't need to be the exact number at that point in time.
> > 
> > Lee, due to this reason lazy culling of unevictable pages is fine too. 
> > 
> > Hugepages, similar to mlocked pages, are special because the user could
> > specify how much memory it wants to reserve for this purpose. So that
> > needs to be taken into consideration i.e it cannot be calculated in some
> > way. 
> 
> Could you just teach the thing to which you are hinting that it also
> needs to go look in sysfs for huge page counts?

:) yeah i could do that too...the point is that its a module and the
function to get the hugepages count is not exported right now. I could
very well add this as an exported symbol and use it from there, but
there can be someone who doesn't want symbols to be unnecessarily
exported if their is no in-tree modular usage of that symbol. 

Other than that it also doesn't quite sound right that I have to query
the kernel for different variables when unevictable should get me all of
user specified locked usage.

Thanks,
Alok

>   Or, is there a
> requirement that it come out of a single meminfo field?
> 
> -- Dave
> 

