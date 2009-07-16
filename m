Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZGPDsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZGPDsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 23:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757353AbZGPDsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 23:48:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57548 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352AbZGPDsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 23:48:41 -0400
Message-ID: <4A5EA2EF.3050501@redhat.com>
Date: Wed, 15 Jul 2009 23:47:59 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH -mm] throttle direct reclaim when too many pages are isolated
 already
References: <20090715223854.7548740a@bree.surriel.com>	<20090716121956.fc50949f.kamezawa.hiroyu@jp.fujitsu.com>	<4A5E9F3D.1040600@redhat.com> <20090716124255.3d601efb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090716124255.3d601efb.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:

>> Am I overlooking something?
>>
> Reclaim from cgorup doesn't come from memory shortage but from
> "it hits limit". Then, it doen't necessary to reclaim pages from
> this zone. fallback to other zone is always ok.
> This will trigger unnecessary wait, I think.

Fair enough.

I'll also change the patch so tasks with a fatal signal
pending will go through congestion_wait at least once,
to give other tasks a chance to free up memory.

That should address everybody's concerns.

-- 
All rights reversed.
