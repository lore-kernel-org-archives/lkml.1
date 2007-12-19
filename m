Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbXLSQIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbXLSQIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbXLSQIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:08:42 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:15401 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbXLSQIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:08:41 -0500
Subject: Re: [patch 17/20] non-reclaimable mlocked pages
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071219095307.683978b0@cuia.boston.redhat.com>
References: <20071218211539.250334036@redhat.com>
	 <20071218211550.186819416@redhat.com>
	 <200712191156.48507.nickpiggin@yahoo.com.au>
	 <20071219084534.4fee8718@bree.surriel.com> <1198074247.6484.17.camel@twins>
	 <20071219095307.683978b0@cuia.boston.redhat.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 19 Dec 2007 11:08:38 -0500
Message-Id: <1198080519.5333.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-19 at 09:53 -0500, Rik van Riel wrote:
> On Wed, 19 Dec 2007 15:24:07 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > I thought Lee had patches that moved pages with long rmap chains (both
> > anon and file) out onto the non-reclaim list, for those a slow
> > background scan does make sense.
> 
> I suspect we won't be needing that code.  The SEQ replacement for
> swap backed pages might reduce the number of pages that need to
> be scanned to a reasonable number.
> 
> Remember, steady states are not a big problem with the current VM.
> It's the sudden burst of scanning that happens when the VM decides
> that it should start swapping (and every anonymous page is referenced)
> that kills large systems.

Yes, I still have the patch [for long anon_vma lists--not for
excessively mapped file, yet] and I'm keeping it up to date and tested.
I do see softlockups on the anon_vma and i_mmap_locks under stress, even
with the reader/writer lock patches.  I'll be trying the workloads on
Rik's latest patches to see if they address these lockups.

Lee

