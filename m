Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbXEJSHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbXEJSHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbXEJSHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:07:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53984 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756816AbXEJSHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:07:08 -0400
Date: Thu, 10 May 2007 11:07:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@osdl.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] memory hotremove patch take 2 [03/10] (drain all pages)
In-Reply-To: <20070509120337.B90A.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0705101105350.10002@schroedinger.engr.sgi.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
 <20070509120337.B90A.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Yasunori Goto wrote:

> This patch add function drain_all_pages(void) to drain all 
> pages on per-cpu-freelist.
> Page isolation will catch them in free_one_page.

This is only draining the pcps of the local processor. I would think 
that you need to drain all other processors pcps of this zone as well. And 
there is no need to drain this processors pcps of other zones.

