Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbXGJPlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbXGJPlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbXGJPll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:41:41 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:37373 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbXGJPlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:41:40 -0400
Message-ID: <4693A813.7090005@linux.vnet.ibm.com>
Date: Tue, 10 Jul 2007 21:08:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
CC: svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com
Subject: Re: [-mm PATCH 6/8] Memory controller add per container LRU and reclaim
 (v2)
References: <20070706052212.11677.26502.sendpatchset@balbir-laptop> <20070710084153.C07D91BF6B5@siro.lan>
In-Reply-To: <20070710084153.C07D91BF6B5@siro.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YAMAMOTO Takashi wrote:
>> Add the meta_page to the per container LRU. The reclaim algorithm has been
>> modified to make the isolate_lru_pages() as a pluggable component. The
>> scan_control data structure now accepts the container on behalf of which
>> reclaims are carried out. try_to_free_pages() has been extended to become
>> container aware.
>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> it seems that the number of pages to scan (nr_active/nr_inactive
> in shrink_zone) is calculated from NR_ACTIVE and NR_INACTIVE of the zone,
> even in the case of per-container reclaim.  is it intended?
> 
> YAMAMOTO Takashi

Good catch again! We do that for now since the per zone LRU is a superset
of the container LRU. I see this as an important TODO item for us -- to
move to reclaim statistics based on per container nr_active and nr_inactive
(to be added).

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
