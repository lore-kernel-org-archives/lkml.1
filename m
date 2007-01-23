Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbXAWBk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbXAWBk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932507AbXAWBk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:40:58 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:53514 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932493AbXAWBk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:40:57 -0500
Date: Mon, 22 Jan 2007 17:40:34 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Balbir Singh <balbir@in.ibm.com>
cc: Andrea Arcangeli <andrea@suse.de>, Niki Hammler <mailinglists@nobaq.net>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
In-Reply-To: <45B56575.10807@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com>
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random>
 <45B56575.10807@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007, Balbir Singh wrote:

> This makes me wonder if it makes sense to split up the LRU into page
> cache LRU and mapped pages LRU. I see two benefits
> 
> 1. Currently based on swappiness, we might walk an entire list
>    searching for page cache pages or mapped pages. With these
>    lists separated, it should get easier and faster to implement
>    this scheme
> 2. There is another parallel thread on implementing page cache
>    limits. If the lists split out, we need not scan the entire
>    list to find page cache pages to evict them.
> 
> Of course I might be missing something (some piece of history)

This means page cache = unmapped file backed page right? Otherwise this 
would not work. I always thought that the page cache were all file backed 
pages both mapped and unmapped.

With the proposed schemd you would have to move pages between lists if 
they are mapped and unmapped by a process. Terminating a process could 
lead to lots of pages moving to the unnmapped list.




