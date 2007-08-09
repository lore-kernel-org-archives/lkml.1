Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbXHIT2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbXHIT2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762510AbXHIT1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:27:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37647 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761011AbXHIT1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:27:20 -0400
Date: Thu, 9 Aug 2007 12:27:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org
Subject: Re: [PATCH 17/23] mm: count writeback pages per BDI
In-Reply-To: <1186687416.11797.182.camel@lappy>
Message-ID: <Pine.LNX.4.64.0708091225470.28074@schroedinger.engr.sgi.com>
References: <20070803123712.987126000@chello.nl>  <20070803125237.072937000@chello.nl>
  <Pine.LNX.4.64.0708091214330.27092@schroedinger.engr.sgi.com>
 <1186687416.11797.182.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Peter Zijlstra wrote:

> Less conditionals. We already have a branch for mapping, why create
> another?

Ah. Okay. This also avoids an interrupt enable disable since you can use 
__ functions. Hmmm... Would be good if we could move the vmstat 
NR_WRITEBACK update there too. Can a page without a mapping be under 
writeback? (Direct I/O?)


