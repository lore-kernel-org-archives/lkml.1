Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZFPOvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZFPOvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZFPOvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:51:35 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:49294 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753063AbZFPOve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:51:34 -0400
Date: Tue, 16 Jun 2009 10:51:05 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       fengguang.wu@intel.com, linuxram@us.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/3] Fix malloc() stall in zone_reclaim() and bring
 behaviour more in line with expectations V3
In-Reply-To: <20090616134423.GD14241@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0906161049180.26093@gentwo.org>
References: <20090615163018.B43A.A69D9226@jp.fujitsu.com> <20090615105651.GD23198@csn.ul.ie> <20090616202157.99AF.A69D9226@jp.fujitsu.com> <20090616134423.GD14241@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Mel Gorman wrote:

> I don't have a particular workload in mind to be perfectly honest. I'm just not
> convinced of the wisdom of trying to unmap pages by default in zone_reclaim()
> just because the NUMA distances happen to be large.

zone reclaim = 1 is supposed to be light weight with minimal impact. The
intend was just to remove potentially unused pagecache pages so that node
local allocations can succeed again. So lets not unmap pages.

