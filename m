Return-Path: <linux-kernel-owner+w=401wt.eu-S1760328AbZDGUPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbZDGUPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbZDGUPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:15:35 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58442 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbZDGUPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:15:34 -0400
Message-ID: <49DBB373.5050800@cs.helsinki.fi>
Date: Tue, 07 Apr 2009 23:11:31 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com> <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com> <49DBAF7E.30704@cs.helsinki.fi> <alpine.DEB.2.00.0904071302430.32321@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0904071302430.32321@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 7 Apr 2009, Pekka Enberg wrote:
>>> I'd be just as happy with the following, although it would require changing
>>> MIN_PARTIAL to be greater than its default of 5 if a node supports more cpus
>>> for optimal performance (the old patch did that automatically up to
>>> MAX_PARTIAL).
>> Hmm but why not move ->min_partial to struct kmem_cache_node as I suggested
>> and make sure it's adjusted properly as with nr_cpus_node()?

David Rientjes wrote:
> Sure, that's also possible except we'd lose the ability to tune 
> min_partial with /sys/kernel/slab/cache/min_partial, unless it would then 
> change n->min_partial for each N_NORMAL_MEMORY node.  We lack an interface 
> to change the per-node min_partial.
> 
> If you think that's acceptable, I'd be just as satisfied with that 
> approach as long as all archs have valid cpu_to_node() mappings at the 
> time of CPU_UP_PREPARE.

Well, that doesn't change the current behavior, so sure, I think it's 
acceptable. And if the new defaults seem reasonable enough, we can 
probably get rid of the tunable altogether.

David Rientjes wrote:
> Aside: we're lacking in the documentation of these sysfs tunables such as 
> remote_node_defrag_ratio to begin with, the only way to figure out what it 
> does is by reading the code or making assumptions based on its name.  I'd 
> be happy to add some documentation but it'd be good to keep it separate 
> from Documentation/vm/slub.txt.

AFAICT, the Documentation/ABI directory is the right place for this kind 
of stuff.

			Pekka
