Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbYJHMaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbYJHMaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 08:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbYJHMaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 08:30:11 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:30789 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753612AbYJHMaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:30:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FHBspMA/q35mu/k6CtnoSjSg+IwYTOLNwUq5Tvv5Gby0U3Girr6hWd+HecoMNPAZeIiI2m+pV+9b/7g7ZcunE7EbYgj8tSssJUJLTCUbr93TJy0z7XdqXZO+ecb6rIG+Rx8499RA0vJvfuUpLnsOAYeXNn8O+UTnWlWMh139ILY=  ;
X-YMail-OSG: 4B1uoAwVM1n2d40.f3xvF3eRQf8jC_NlIeVL0FZHAo0ol4JciPS7sKnuJcBlokXTuKX0bsPB9tXHcKg20IiYbX2wJWnsFbRlugKFEXXBZmE66iJv6RvYNY8MMn.Nn1z5R0zncZTvCy0AY1tEJ17jMYihfya.V7O9n5iVDZVAvSEnQNCx2b30S0O2OjXD
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 1/1] hugetlbfs: handle pages higher order than MAX_ORDER
Date: Wed, 8 Oct 2008 23:29:59 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>
References: <1223458431-12640-1-git-send-email-apw@shadowen.org> <1223458431-12640-2-git-send-email-apw@shadowen.org>
In-Reply-To: <1223458431-12640-2-git-send-email-apw@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810082329.59561.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 20:33, Andy Whitcroft wrote:
> When working with hugepages, hugetlbfs assumes that those hugepages
> are smaller than MAX_ORDER.  Specifically it assumes that the mem_map
> is contigious and uses that to optimise access to the elements of the
> mem_map that represent the hugepage.  Gigantic pages (such as 16GB pages
> on powerpc) by definition are of greater order than MAX_ORDER (larger
> than MAX_ORDER_NR_PAGES in size).  This means that we can no longer make
> use of the buddy alloctor guarentees for the contiguity of the mem_map,
> which ensures that the mem_map is at least contigious for maximmally
> aligned areas of MAX_ORDER_NR_PAGES pages.
>
> This patch adds new mem_map accessors and iterator helpers which handle
> any discontiguity at MAX_ORDER_NR_PAGES boundaries.  It then uses these
> within copy_huge_page, clear_huge_page, and follow_hugetlb_page to allow
> these to handle gigantic pages.
>
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>

Seems good to me... but do you have to add lots of stuff into the end of
the for statements? Why not just at the end of the block?
