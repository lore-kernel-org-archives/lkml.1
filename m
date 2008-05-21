Return-Path: <linux-kernel-owner+w=401wt.eu-S936070AbYEUS6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936070AbYEUS6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbYEUS6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:58:23 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57251 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbYEUS6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:58:22 -0400
Message-ID: <4834704D.6020809@cs.helsinki.fi>
Date: Wed, 21 May 2008 21:56:13 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-kernel@vger.kernel.org, mpm@selenic.com, lethal@linux-sh.org,
       dhowells@redhat.com
Subject: Re: [RFC/PATCH 2/3] SLUB: make ksize() more strict for page allocator
 pass-through
References: <Pine.LNX.4.64.0805212125310.22291@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0805211149210.16064@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805211149210.16064@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Why is it too big? Without your additions it is converting kmallocs 
> inline to get_free_pages(). That results in a simple function call with 
> two constant parameters.

Well, it's a PITA because of #include dependencies in any case. Is 
moving it out-of-line a problem?

Christoph Lameter wrote:
> The patch touches the page struct uselessly. I think the PageSlab marking 
> is useful for debugging but not for a production kernel.

Hmm, where? page_address() already references ->virtual. I suppose 
CONFIG_SLUB_DEBUG is a no no as well then so do we want to add a 
CONFIG_KSIZE_DEBUG config option...? (Btw, I removed the BUG_ON() from 
kfree() as spotted by Vegard Nossum.)

			Pekka
