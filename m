Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYDWOIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYDWOIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 10:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYDWOH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 10:07:56 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:7403 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbYDWOHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 10:07:55 -0400
To: Mel Gorman <mel@csn.ul.ie>
Cc: wli@holomorphy.com, agl@us.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reserve huge pages for reliable MAP_PRIVATE hugetlbfs mappings
From: Andi Kleen <andi@firstfloor.org>
References: <20080421183621.GA13100@csn.ul.ie>
Date: Wed, 23 Apr 2008 15:55:10 +0200
In-Reply-To: <20080421183621.GA13100@csn.ul.ie> (Mel Gorman's message of "Mon, 21 Apr 2008 19:36:22 +0100")
Message-ID: <87hcdsznep.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Apr 2008 13:48:21.0856 (UTC) FILETIME=[B1C1DE00:01C8A548]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mel@csn.ul.ie> writes:

> MAP_SHARED mappings on hugetlbfs reserve huge pages at mmap() time. This is
> so that all future faults will be guaranteed to succeed. Applications are not
> expected to use mlock() as this can result in poor NUMA placement.
>
> MAP_PRIVATE mappings do not reserve pages. This can result in an application
> being SIGKILLed later if a large page is not available at fault time. This
> makes huge pages usage very ill-advised in some cases as the unexpected
> application failure is intolerable. Forcing potential poor placement with
> mlock() is not a great solution either.
>
> This patch reserves huge pages at mmap() time for MAP_PRIVATE mappings similar
> to what happens for MAP_SHARED mappings. 

This will break all applications that mmap more hugetlbpages than they
actually use. How do you know these don't exist?

> Opinions?

Seems like a risky interface change to me.

-Andi
