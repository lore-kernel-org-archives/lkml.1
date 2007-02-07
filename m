Return-Path: <linux-kernel-owner+w=401wt.eu-S1161299AbXBGOGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161299AbXBGOGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161320AbXBGOGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:06:07 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:33734 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161299AbXBGOGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:06:04 -0500
Date: Wed, 7 Feb 2007 06:05:56 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com, clameter@engr.sgi.com, akpm@osdl.org
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
In-Reply-To: <20070207190738.30f1d419.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0702070604090.14056@schroedinger.engr.sgi.com>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
 <p73ejp2mfqh.fsf@bingen.suse.de> <20070207190738.30f1d419.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007, KAMEZAWA Hiroyuki wrote:

> > IMHO there shouldn't be any memory less nodes. The architecture code
> > should not create them. The CPU should be assigned to a nearby node instead.
> > At least x86-64 ensures that.
> > 
> AFAIK, ia64 creates nodes just depends on SRAT's possible resource information.
> Then, ia64 can create cpu-memory-less-node(node with no available resource.).
> (*)I don't like this.

I think that is only true for !SN2 platforms? Could we fix this?

> If we don't allow memory-less-node, we may have to add several codes for cpu-hot-add.
> cpus should be moved to nearby node at hotadd .
> And node-hot-add have to care that cpus mustn't be added before memory, cpu-driven 
> node-hot-add will never occur. (ACPI's 'container' device spec can't guaranntee this.)

Well you could bring down the cpu and bring it up again? This would also 
assure the best placement of the runtime structures for node?

