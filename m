Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbZBEDTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbZBEDTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 22:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbZBEDTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:19:15 -0500
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:43944 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753262AbZBEDTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:19:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=chuw98oIOeehc+D2xHCW8nZvIhyjfyVtreqpYieyO3UAvXpbZzcCnW26ZncJOe5FgG1nuKF11btGMh5PDehSnzNdG8Ak6h/OnmfQF8xjeUfzmeKgmcR5imay9v7fKFlAeaHJazvEJOFB4Y9pkqQug2nXMlJxvL1dAC3PrgMYMms=  ;
X-YMail-OSG: .Vzupf4VM1l2s7LKsUaufJ7MExtkzkz1kG0E8dPYaqgwJAsNLdcYjOeU_8Rfj.VWNPsffHuW3JIF45LZzde41mvJeU6mslvBKmYSLLif3Uv4kmJ6rt6HIh6OOGEku9hZCp06gWe9uxVCcvovAsI6fL2yYsyZrsuMwZ2VPxe_AcHpc0feMwwc3iHn53vUeA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
Date: Thu, 5 Feb 2009 14:18:46 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20090114155923.GC1616@wotan.suse.de> <200902041522.01307.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0902041507050.8154@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0902041507050.8154@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051418.47523.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 07:09:15 Christoph Lameter wrote:
> On Wed, 4 Feb 2009, Nick Piggin wrote:
> > That's very true, and we touched on this earlier. It is I guess
> > you can say a downside of queueing. But an analogous situation
> > in SLUB would be that lots of pages on the partial list with
> > very few free objects, or freeing objects to pages with few
> > objects in them. Basically SLUB will have to do the extra work
> > in the fastpath.
>
> But these are pages with mostly allocated objects and just a few objects
> free. The SLAB case is far worse: You have N objects on a queue and they
> are keeping possibly N pages away from the page allocator and in those
> pages *nothing* is used.

Periodic queue trimming should prevent this from becoming a big problem.
It will trim away those objects, and so subsequent allocations will come
from new pages and be densely packed. I don't think I've seen a problem
in SLAB reported from this phenomenon, so I'm not too concerned about it
at the moment.


