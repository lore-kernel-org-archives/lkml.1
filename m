Return-Path: <linux-kernel-owner+w=401wt.eu-S932452AbXBNTAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbXBNTAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932454AbXBNTAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:00:09 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:43414 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932452AbXBNTAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:00:07 -0500
Date: Wed, 14 Feb 2007 11:00:02 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Nick Piggin <npiggin@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [patch] mm: NUMA replicated pagecache
In-Reply-To: <20070213060924.GB20644@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0702141057060.975@schroedinger.engr.sgi.com>
References: <20070213060924.GB20644@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Nick Piggin wrote:

> This is a scheme for page replication replicates read-only pagecache pages
> opportunistically, at pagecache lookup time (at points where we know the
> page is being looked up for read only).

The problem is that you may only have a single page table. One process 
with multiple threads will just fault in one thread in order to 
install the mapping to the page. The others threads may be running on 
different nodes and different processors but will not generate any 
faults. Pages will not be replicated as needed. The scheme only seems to 
be working for special cases of multiple processes mapping the same file.
 
