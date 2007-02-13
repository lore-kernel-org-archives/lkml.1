Return-Path: <linux-kernel-owner+w=401wt.eu-S1751196AbXBMIkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbXBMIkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXBMIkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:40:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37676 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbXBMIkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:40:52 -0500
Date: Tue, 13 Feb 2007 17:38:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, clameter@sgi.com,
       bob.picco@hp.com
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
Message-Id: <20070213173830.285c3838.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200702130929.49349.andi@firstfloor.org>
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com>
	<200702130929.49349.andi@firstfloor.org>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 09:29:49 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> 
> > In my understanding, a "node" is a block of cpu, memory, devices.
> > and there could be cpu-only-node, memory-only-node, device-only-node...
> 
> The trouble with this is that you'll need to harden large parts
> of code against these.  Especially a NULL pgdat is something quite
> dangerous. You could make it a dummy empty pgdat, but just assigning it
> nearby seems easier.

Ah...It seems I didn't explain enough.

Now, memorly-less-node has its own pgdat, for its own zonelist.
All *online* node has its own NODA_DATA(nid).

NOD_DATA(nid) is always valid pointer if a node is online.
NODE_DATA(nid)->present_pages can be 0 even if a node is online, 
I call this as memory-less-node.

Thanks,
-Kame


