Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbZFWXs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbZFWXs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZFWXsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:48:18 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40380 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115AbZFWXsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:48:18 -0400
Subject: Re: [PATCH] Hugepages should be accounted as unevictable pages.
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: akataria@vmware.com
Cc: Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Mel Gorman <mel@csn.ul.ie>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1245799709.24110.70.camel@alok-dev1>
References: <20090623093459.2204.A69D9226@jp.fujitsu.com>
	 <1245732411.18339.6.camel@alok-dev1>
	 <20090623135017.220D.A69D9226@jp.fujitsu.com>
	 <20090623141147.8f2cef18.kamezawa.hiroyu@jp.fujitsu.com>
	 <1245736441.18339.21.camel@alok-dev1>  <4A41481D.1060607@redhat.com>
	 <1245793331.24110.33.camel@alok-dev1>  <4A414F55.2040808@redhat.com>
	 <1245794811.24110.41.camel@alok-dev1>  <4A415D62.20109@redhat.com>
	 <1245799709.24110.70.camel@alok-dev1>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 16:48:17 -0700
Message-Id: <1245800897.31856.28.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 16:28 -0700, Alok Kataria wrote:
> Now regarding the patch that I posted, I need a way to get the
> hugepages count, there are 2 ways of doing this. 
> 1. exporting hugetlb_total_pages function for module usage.

Unfortunately, that won't even be enough.  That only accounts for the
default hstate.  There may be several hstate if the system supports
multiple large page sizes.  It's all exported in sysfs, but I don't see
any simple way (other than sys_open()) for a module to get at it.

-- Dave

