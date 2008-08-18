Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbYHRTWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbYHRTWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYHRTWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:22:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754197AbYHRTWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:22:30 -0400
Message-ID: <48A9CBB3.6030700@linux-foundation.org>
Date: Mon, 18 Aug 2008 14:21:23 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Adam Litke <agl@us.ibm.com>
CC: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       nacc <nacc@linux.vnet.ibm.com>, mel@csn.ul.ie, apw <apw@shadowen.org>,
       agl <agl@linux.vnet.ibm.com>
Subject: Re: [BUG] __GFP_THISNODE is not always honored
References: <1218837685.12953.11.camel@localhost.localdomain>
In-Reply-To: <1218837685.12953.11.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Litke wrote:
>
> So far my debugging has led me to get_page_from_freelist() inside the
> for_each_zone_zonelist() loop.  When buffered_rmqueue() returns a page I
> compare the value of page_to_nid(page), zone->node and the node that the
> hugetlb code requested with __GFP_THISNODE.  These all match -- except when the
> problem triggers.  In that case, zone->node matches the node we asked for but
> page_to_nid() does not.

Uhhh.. A page that was just taken off the freelist? So we may have freed or
coalesced a page to the wrong zone? Looks like there is something more
fundamental that broke here.
