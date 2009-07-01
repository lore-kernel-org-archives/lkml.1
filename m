Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZGARW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZGARW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZGARWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:22:39 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:54768 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754451AbZGARWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:22:37 -0400
Date: Wed, 1 Jul 2009 13:22:33 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: yakui <yakui.zhao@intel.com>
cc: "Li, Shaohua" <shaohua.li@intel.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>
Subject: Re: + memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
 added to -mm tree
In-Reply-To: <1246419543.18688.14.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0907011317030.9522@gentwo.org>
References: <200906291949.n5TJnuov028806@imap1.linux-foundation.org>  <alpine.DEB.1.10.0906291804340.21956@gentwo.org>  <20090630004735.GA21254@sli10-desk.sh.intel.com>  <20090701025558.GA28524@sli10-desk.sh.intel.com>
 <1246419543.18688.14.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, yakui wrote:

> If we can't allocate memory from other node when there is no memory on
> this node, we will have to do something like the bootmem allocator.
> After the memory page is added to the system memory, we will have to
> free the memory space used by the memory allocator. At the same time we
> will have to assure that the hot-plugged memory exists physically.

The bootmem allocator must stick around it seems. Its more like a node
bootstrap allocator then.

Maybe we can generalize that. The bootstrap allocator may only need to be
able boot one node (which simplifies design). During system bringup only
the boot node is brought up.

Then the other nodes are hotplugged later all in turn using the bootstrap
allocator for their node setup?

There are a couple of things where one would want to spread out memory
across the nodes at boot time. How would node hotplugging handle that
situation?
