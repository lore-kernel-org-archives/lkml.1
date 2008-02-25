Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbYBYRsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbYBYRsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbYBYRse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:48:34 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:34142 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbYBYRsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:48:33 -0500
Subject: Re: Page scan keeps touching kernel text pages
From: Dave Hansen <haveblue@us.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080225150724.GF2604@shadowen.org>
References: <20080224144710.GD31293@lazybastard.org>
	 <20080225150724.GF2604@shadowen.org>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 09:48:22 -0800
Message-Id: <1203961702.6662.35.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-25 at 15:07 +0000, Andy Whitcroft wrote:
> shrink_page_list() would be expected to be passed pages pulled from
> the active or inactive lists via isolate_lru_pages()?  I would not have
> expected to find the kernel text on the LRU and therefore not expect to
> see it passed to shrink_page_list()?

It may have been kernel text at one time, but what about __init
functions?  Don't we free that section back to the normal allocator
after init time?  Those can end up on the LRU.

-- Dave

