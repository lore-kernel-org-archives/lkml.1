Return-Path: <linux-kernel-owner+w=401wt.eu-S1030192AbXAXFrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192AbXAXFrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 00:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030217AbXAXFrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 00:47:47 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:41520 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030192AbXAXFrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 00:47:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ckeF8MMVamG3qw5SbZSCJ8oSLM9kScF2WzbIJUyI9HtFqXhCc/0JfwRSDySoYSLza3ZTTiUpxdqdm+1xXEsScQJdulv8cSeh41iOI51pFcqy0e/bDZ1KphpdqQL9rfmqPb0TQNydHwFoRIVNCrM3HD8Yg7ou34+NcQpziruwDdY=
Message-ID: <6d6a94c50701232147g7453fe79q6ce0df94da2ac749@mail.gmail.com>
Date: Wed, 24 Jan 2007 13:47:44 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [RFC] Limit the size of the pagecache
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       rgetz@blackfin.uclinux.org, Michael.Hennerich@analog.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Bryan Wu" <cooloney.lkml@gmail.com>
In-Reply-To: <20070124115310.48cda374.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
	 <20070124115310.48cda374.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph's patch is better than mine. The only thing I think is that
zone->max_pagecache_pages should be checked never less than
zone->pages_low.

The good part of the patch is using the existing reclaimer. But the
problem in my opinion of the idea is the existing reclaimer too. Think
of  when vfs cache limit is
hit, reclaimer doesn't reclaim all of the reclaimable pages, it just
give few out. So next time vfs pagecache request, it is quite possible
reclaimer is triggered again. That means after limit is hit, reclaim
will be implemented every time fs ops allocating memory. That's the
point in my mind impacting the performance of the applications.

-Aubrey
