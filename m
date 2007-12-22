Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbXLVU1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbXLVU1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXLVU1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:27:42 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:38579 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbXLVU1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:27:42 -0500
Message-ID: <476D7334.4010301@linux.vnet.ibm.com>
Date: Sun, 23 Dec 2007 01:57:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lee.shermerhorn@hp.com
Subject: Re: [patch 00/20] VM pageout scalability improvements
References: <20071218211539.250334036@redhat.com>
In-Reply-To: <20071218211539.250334036@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On large memory systems, the VM can spend way too much time scanning
> through pages that it cannot (or should not) evict from memory. Not
> only does it use up CPU time, but it also provokes lock contention
> and can leave large systems under memory presure in a catatonic state.
> 

Hi, Rik,

I remember you mentioning that by large memory systems you mean systems
with at-least 128GB, does this definition still hold?

> This patch series improves VM scalability by:
> 
> 1) making the locking a little more scalable
> 
> 2) putting filesystem backed, swap backed and non-reclaimable pages
>    onto their own LRUs, so the system only scans the pages that it
>    can/should evict from memory
> 
> 3) switching to SEQ replacement for the anonymous LRUs, so the
>    number of pages that need to be scanned when the system
>    starts swapping is bound to a reasonable number
> 
> The noreclaim patches come verbatim from Lee Schermerhorn and
> Nick Piggin.  I have not taken a detailed look at them yet and
> all I have done is fix the rejects against the latest -mm kernel.
> 

Is there a consolidate patch available, it makes it easier to test.

> I am posting this series now because I would like to get more
> feedback, while I am studying and improving the noreclaim patches
> myself.
> 

What kind of tests show the problem? I'll try and review and test the code.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
