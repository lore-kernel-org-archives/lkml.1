Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0BDRrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:47:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab0BDRre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:47:34 -0500
Date: Thu, 4 Feb 2010 18:47:15 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: balbir@linux.vnet.ibm.com, jdike@addtoit.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH] emulate accessed bit for EPT
Message-ID: <20100204174715.GL5959@random.random>
References: <20100203161103.11e2b572@annuminas.surriel.com>
 <20100204041212.GI19641@balbir.in.ibm.com>
 <4B6ACE5B.9080601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6ACE5B.9080601@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 08:40:43AM -0500, Rik van Riel wrote:
> I suspect it won't be very many. I have been monitoring
> /proc/meminfo on my system while testing this patch, and
> it is quite typical that the size of the inactive anon
> list does not change for minutes at a time.
> 
> In other words, no pages are moved onto or off of the
> inactive anon list for several minutes. That corresponds
> to a very small number of minor faults introduced by my
> patch.

When there's light VM pressure, ideally there should be zero overhead
caused by the patch. When there is VM pressure this will avoid some
unnecessary I/O which should outweight the minor faults. It should be
a good default behavior.
