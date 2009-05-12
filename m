Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbZELPGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbZELPGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZELPFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:05:46 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54311 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbZELPFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:05:45 -0400
Subject: Re: [RFC] Replace the watermark-related union in struct zone with 
 awatermark[] array V2
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090512141331.GI25923@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	 <1240408407-21848-19-git-send-email-mel@csn.ul.ie>
	 <alpine.DEB.2.00.0904221251350.14558@chino.kir.corp.google.com>
	 <20090427170054.GE912@csn.ul.ie>
	 <alpine.DEB.2.00.0904271340320.11972@chino.kir.corp.google.com>
	 <20090427205400.GA23510@csn.ul.ie>
	 <alpine.DEB.2.00.0904271400450.11972@chino.kir.corp.google.com>
	 <20090430133524.GC21997@csn.ul.ie> <1241099300.29485.96.camel@nimitz>
	 <20090512141331.GI25923@csn.ul.ie>
Content-Type: text/plain
Date: Tue, 12 May 2009 08:05:39 -0700
Message-Id: <1242140739.8109.40078.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 15:13 +0100, Mel Gorman wrote:
> Changelog since V1
>   o Use N_wmark_pages accessors instead of array accesses
> 
> Patch page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark
> from -mm added a union to struct zone where the watermarks could be accessed
> with either zone->pages_* or a pages_mark array. The concern was that this
> aliasing caused more confusion that it helped.
> 
> This patch replaces the union with a watermark array that is indexed with
> WMARK_* defines accessed via helpers. All call sites that use zone->pages_*
> are updated to use the helpers for accessing the values and the array
> offsets for setting.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> --- 
>  Documentation/sysctl/vm.txt |   11 ++++++-----
>  Documentation/vm/balance    |   18 +++++++++---------
>  arch/m32r/mm/discontig.c    |    6 +++---
>  include/linux/mmzone.h      |   20 ++++++++++++++------
>  mm/page_alloc.c             |   41 +++++++++++++++++++++--------------------
>  mm/vmscan.c                 |   39 +++++++++++++++++++++------------------
>  mm/vmstat.c                 |    6 +++---
>  7 files changed, 77 insertions(+), 64 deletions(-)

Looks nice.  It net adds a few lines of code, but that's mostly from the
#defines and not added complexity or lots of line wrapping.  

Ackedf-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

