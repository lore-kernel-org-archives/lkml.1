Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab0CBVRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:17:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:12525 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab0CBVRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:17:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SP0mNP0N25vrefe0Ma/7uXqf78tZLD3KCZMNh6CCdkgV0pUzXEvcpg5oIIY5ezvn6
	EJT3Jn+c2yqvAY/JwZvQg==
Date: Tue, 2 Mar 2010 13:17:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] slab: add memory hotplug support
In-Reply-To: <20100302125306.GD19208@basil.fritz.box>
Message-ID: <alpine.DEB.2.00.1003021303220.18137@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi> <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com> <alpine.DEB.2.00.1002251228140.18861@router.home> <20100226114136.GA16335@basil.fritz.box>
 <alpine.DEB.2.00.1002260904311.6641@router.home> <20100226155755.GE16335@basil.fritz.box> <alpine.DEB.2.00.1002261123520.7719@router.home> <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com> <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com>
 <20100302125306.GD19208@basil.fritz.box>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010, Andi Kleen wrote:

> The patch looks far more complicated than my simple fix.
> 
> Is more complicated now better?
> 

If you still believe these are "fixes," then perhaps you don't fully 
understand the issue: slab completely lacked memory hotplug support when a 
node is either being onlined or offlined that do not have hotadded or 
hotremoved cpus.  It's as simple as that.

To be fair, my patch may appear more complex because it implements full 
memory hotplug support so that the nodelists are properly drained and 
freed when the same memory regions you onlined for memory hot-add are now 
offlined.  Notice, also, how it touches no other slab code as implementing 
new support for something shouldn't.  There is no need for additional 
hacks to be added in other slab code if you properly allocate and 
initialize the nodelists for the memory being added before it is available 
for use by the kernel.

If you'd test my patch out on your setup, that would be very helpful.  I 
can address any additional issues that you may undercover if you post the 
oops while doing either memory online or offline.
