Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbYEDFaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYEDFaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 01:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYEDF35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 01:29:57 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:51419 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbYEDF34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 01:29:56 -0400
Date: Sat, 3 May 2008 22:29:55 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Mel Gorman <mel@csn.ul.ie>, wli@holomorphy.com, agl@us.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reserve huge pages for reliable MAP_PRIVATE hugetlbfs
 mappings
In-Reply-To: <87hcdsznep.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.1.10.0805032227570.27385@twinlark.arctic.org>
References: <20080421183621.GA13100@csn.ul.ie> <87hcdsznep.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008, Andi Kleen wrote:

> Mel Gorman <mel@csn.ul.ie> writes:
> 
> > MAP_SHARED mappings on hugetlbfs reserve huge pages at mmap() time. This is
> > so that all future faults will be guaranteed to succeed. Applications are not
> > expected to use mlock() as this can result in poor NUMA placement.
> >
> > MAP_PRIVATE mappings do not reserve pages. This can result in an application
> > being SIGKILLed later if a large page is not available at fault time. This
> > makes huge pages usage very ill-advised in some cases as the unexpected
> > application failure is intolerable. Forcing potential poor placement with
> > mlock() is not a great solution either.
> >
> > This patch reserves huge pages at mmap() time for MAP_PRIVATE mappings similar
> > to what happens for MAP_SHARED mappings. 
> 
> This will break all applications that mmap more hugetlbpages than they
> actually use. How do you know these don't exist?

such applications couldn't have existed before the change which added 
HugePages_Rsvd... which i admit was sometime between 2.6.11 and 2.6.18 but 
from my point of view the inability to actually allocate hugepages without 
trapping SIGSEGV/etc was a terrible bug introduced when HugePages_Rsvd was 
introduced.

-dean
