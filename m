Return-Path: <linux-kernel-owner+w=401wt.eu-S1751455AbXBMSSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbXBMSSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXBMSSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:18:51 -0500
Received: from ns1.suse.de ([195.135.220.2]:35713 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbXBMSSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:18:51 -0500
From: Andi Kleen <ak@suse.de>
To: "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
Date: Tue, 13 Feb 2007 19:18:45 +0100
User-Agent: KMail/1.9.5
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Christoph Lameter <clameter@sgi.com>, bob.picco@hp.com
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com> <200702131845.05913.ak@suse.de> <45D1FF43.9050800@mbligh.org>
In-Reply-To: <45D1FF43.9050800@mbligh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131918.45885.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I wasn't suggesting having NULL pointers for pgdats, if that's what you
> mean. 

That is what started the original thread at least. Can happen on some
ia64 platforms.

> Just nodes with no memory in them, the pgdat would still be there. 
> pgdat = struct node, except everything's badly named.

Ok those can happen even on x86-64, mostly because it's possible
to fill up a node early during boot up with bootmem and then
it's effectively empty.

[there is even still a open bug when this happens on node 0]
 
Handling out of memory here of course has to be always done.

Just NULL pointers in core data structures are evil. But I'm glad we 
agree here.

Now if it's better to set up a empty node or use a nearby node
for a memory less cpu can be further discussed. I still think
I lean towards the later.

-Andi
