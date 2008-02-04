Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYBDTDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYBDTDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbYBDTDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:03:36 -0500
Received: from relay2.sgi.com ([192.48.171.30]:57900 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757089AbYBDTDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:03:36 -0500
Date: Mon, 4 Feb 2008 11:03:32 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee.Schermerhorn@hp.com
Subject: Re: [2.6.24-rc8-mm1][regression?] numactl --interleave=all doesn't
 works on memoryless node.
In-Reply-To: <20080202113045.GA29441@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0802041101290.9656@schroedinger.engr.sgi.com>
References: <20080202165054.F491.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <20080202090914.GA27723@one.firstfloor.org> <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <20080202113045.GA29441@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Feb 2008, Andi Kleen wrote:

> To be honest I've never tried seriously to make 32bit NUMA policy
> (with highmem) work well; just kept it at a "should not break"
> level. That is because with highmem the kernel's choices at 
> placing memory are seriously limited anyways so I doubt 32bit
> NUMA will ever work very well.

Memory policies do not work reliably with config highmem (I have never 
seen such usage because large memory systems are typically 64 bit 
which have no highmem, but there are some 32bit numa uses of HIGHMEM) ....

Memory policies are only applied to the highest zone. So if a system has 
highmem on some nodes and not on the others then policies will only be 
applied if allocations happen to occur on the highmem nodes.
