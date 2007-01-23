Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXAWD2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXAWD2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 22:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932694AbXAWD2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 22:28:45 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:49177 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932436AbXAWD2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 22:28:44 -0500
Date: Mon, 22 Jan 2007 19:28:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Balbir Singh <balbir@in.ibm.com>
cc: Andrea Arcangeli <andrea@suse.de>, Niki Hammler <mailinglists@nobaq.net>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
In-Reply-To: <45B57E73.3000307@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0701221923300.30667@schroedinger.engr.sgi.com>
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random>
 <45B56575.10807@in.ibm.com> <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com>
 <45B57E73.3000307@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007, Balbir Singh wrote:

> When you unmap or map, you need to touch the pte entries and know the
> pages involved, so shouldn't be equivalent to a list_del and list_add
> for each page impacted by the map/unmap operation?

When you unmap and map you must currently get exclusive access to the 
cachelines of the pte and the cacheline of the page struct. If we use a 
list_move on page->lru then we have would have to update pointers in up 
to 4 other page structs. Thus we need exclusive access to 4 additional 
cachelines. This triples the number of cachelines touched. Instead of 2 
cachelines we need 6.


