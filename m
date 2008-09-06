Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYIFFmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYIFFmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 01:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYIFFlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 01:41:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbYIFFlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 01:41:51 -0400
Date: Sat, 6 Sep 2008 01:42:14 -0400
From: Rik van Riel <riel@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Hamid R. Jahanjou" <hamid.jahanjou@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
Message-ID: <20080906014214.22f28548@riellaptop.surriel.com>
In-Reply-To: <20080905194501.GZ18288@one.firstfloor.org>
References: <48BFCECE.90103@gmail.com>
	<87iqtbuez9.fsf@basil.nowhere.org>
	<48C19648.8030002@gmail.com>
	<20080905194501.GZ18288@one.firstfloor.org>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 21:45:01 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Yes, but that has nothing to do in how much you should swap cluster.
> 
> AFAIK the main motivation for swap clustering is to avoid the extreme
> seekiness that happens during swap in (that is the main reason
> why swap on Linux often takes so long). And also to use the IO
> device well. IO devices today typically have a "minimum useful 
> unit of IO" which is much larger than a page. Typically it's at least
> a MB, sometimes even more e.g. on flash or on some RAID controllers.  

That is indeed the reason.

Basically, the swap IO size should be large enough that
swap throughput is not incredibly slow when swapping in
lots of related data in a process.

On the other hand, you do want to avoid evicting data 
that the process is still using, just because you are 
swapping out a not recently referenced page on a
nearby virtual address.

I suspect that the swap IO cluster could contain nearby
and virtually contiguous pages that are (1) not recently
referenced and (2) on the inactive list.

Of course, my guess may be wrong - this needs testing :)

-- 
All rights reversed.
