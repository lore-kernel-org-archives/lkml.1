Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZLWKKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZLWKKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbZLWKKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:10:23 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:57839 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbZLWKKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:10:22 -0500
Message-ID: <4B31EC7C.7000302@gmail.com>
Date: Wed, 23 Dec 2009 11:10:04 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Haicheng Li <haicheng.li@linux.intel.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: initialize unused alien cache entry as NULL at
 alloc_alien_cache().
References: <4B30BDA8.1070904@linux.intel.com> <alpine.DEB.2.00.0912220945250.12048@router.home> <4B31BE44.1070308@linux.intel.com>
In-Reply-To: <4B31BE44.1070308@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 23 Dec 2009 11:10:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 23/12/2009 07:52, Haicheng Li a écrit :
> Christoph & Matt,
> 
> Thanks for the review. Node ids beyond nr_node_ids could be used in the
> case of
> memory hotadding.
> 
> Let me explain here:
> Firstly, original nr_node_ids = 1 + nid of highest POSSIBLE node.
> 
> Secondly, consider hotplug-adding the memories that are on a new_added
> node:
> 1. when acpi event is triggered:
> acpi_memory_device_add() -> acpi_memory_enable_device() -> add_memory()
> -> node_set_online()
> 
> The node_state[N_ONLINE] is updated with this new node added.
> And the id of this new node is beyond nr_node_ids.
> 

Then, this is a violation of the first statement :

nr_node_ids = 1 + nid of highest POSSIBLE node.

If your system allows hotplugging of new nodes, then POSSIBLE nodes should include them
at boot time.

Same thing for cpus and nr_cpus_ids. If a cpu is added, then its id MUST be < nr_cpus_ids
