Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbXBMS2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbXBMS2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbXBMS2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:28:15 -0500
Received: from dvhart.com ([64.146.134.43]:56637 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbXBMS2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:28:14 -0500
Message-ID: <45D202D8.9080503@mbligh.org>
Date: Tue, 13 Feb 2007 10:26:32 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Christoph Lameter <clameter@sgi.com>, bob.picco@hp.com
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com> <200702131845.05913.ak@suse.de> <45D1FF43.9050800@mbligh.org> <200702131918.45885.ak@suse.de>
In-Reply-To: <200702131918.45885.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> I wasn't suggesting having NULL pointers for pgdats, if that's what you
>> mean. 
> 
> That is what started the original thread at least. Can happen on some
> ia64 platforms.

OK, that does seem kind of ugly.

>> Just nodes with no memory in them, the pgdat would still be there. 
>> pgdat = struct node, except everything's badly named.
> 
> Ok those can happen even on x86-64, mostly because it's possible
> to fill up a node early during boot up with bootmem and then
> it's effectively empty.
> 
> [there is even still a open bug when this happens on node 0]
>  
> Handling out of memory here of course has to be always done.

Yup, if we just set the "size" of the node to zero, it seems
like a natural degenerate case that should be handled anyway.

> Just NULL pointers in core data structures are evil. But I'm glad we 
> agree here.
> 
> Now if it's better to set up a empty node or use a nearby node
> for a memory less cpu can be further discussed. I still think
> I lean towards the later.

Just seems kind of ugly and unnecessary, particularly if that
memory-less cpu (or IO node) is equidistant from one or more
memory-possessing nodes. As long as their zonelist is set up
correctly, it should all work fine without that, right?

build_zonelists_node already checks populated_zone() so it looks
like it's all set up for that already ...

M.

