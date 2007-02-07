Return-Path: <linux-kernel-owner+w=401wt.eu-S1030614AbXBGKIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030614AbXBGKIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030618AbXBGKIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:08:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39864 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030614AbXBGKI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:08:29 -0500
Date: Wed, 7 Feb 2007 19:07:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, clameter@engr.sgi.com,
       akpm@osdl.org
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
Message-Id: <20070207190738.30f1d419.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <p73ejp2mfqh.fsf@bingen.suse.de>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
	<p73ejp2mfqh.fsf@bingen.suse.de>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07 Feb 2007 11:20:06 +0100
Andi Kleen <ak@suse.de> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> 
> > current mempolicy just checks whether a node is online or not.
> > If there is memory-less-node, mempolicy's target node can be
> > invalid.
> > This patch adds a check whether a node has memory or not.
> 
> IMHO there shouldn't be any memory less nodes. The architecture code
> should not create them. The CPU should be assigned to a nearby node instead.
> At least x86-64 ensures that.
> 
AFAIK, ia64 creates nodes just depends on SRAT's possible resource information.
Then, ia64 can create cpu-memory-less-node(node with no available resource.).
(*)I don't like this.

If we don't allow memory-less-node, we may have to add several codes for cpu-hot-add.
cpus should be moved to nearby node at hotadd .
And node-hot-add have to care that cpus mustn't be added before memory, cpu-driven 
node-hot-add will never occur. (ACPI's 'container' device spec can't guaranntee this.)

-Kame



