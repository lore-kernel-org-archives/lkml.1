Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZF3BDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZF3BDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZF3BDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:03:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:15015 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbZF3BDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:03:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,312,1243839600"; 
   d="scan'208";a="426360007"
Date: Tue, 30 Jun 2009 09:03:02 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "mel@csn.ul.ie" <mel@csn.ul.ie>, "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: +
	memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
	added to -mm tree
Message-ID: <20090630010302.GD21254@sli10-desk.sh.intel.com>
References: <200906291949.n5TJnrsO028716@imap1.linux-foundation.org> <alpine.DEB.1.10.0906291818460.21956@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906291818460.21956@gentwo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 06:20:00AM +0800, Christoph Lameter wrote:
> On Mon, 29 Jun 2009, akpm@linux-foundation.org wrote:
> 
> > Pages marked as isolated should not be allocated again.  If such pages
> > reside in pcp list, they can be allocated too, so there is a ping-pong
> > memory offline frees some pages to pcp list and the pages get allocated
> > and then memory offline frees them again, this loop will happen again and
> > again.
> 
> Isolated pages are freed? Could they not be kept on a separate
> list with refcount elevated until the isolation procedure is complete?
Yes, they can be freed and add into pcp list. Moving them to a separate list
is feasible, but the approach is more intrusive to me. As I explained in the
patch, adding check in buffered_rmqueue() should hasn't impact for normal path.

Thanks,
Shaohua
