Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbYBEMcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbYBEMcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 07:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYBEMcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 07:32:11 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:36810 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYBEMcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 07:32:09 -0500
Message-ID: <47A856E1.4040703@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2008 18:00:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, tglx@linutronix.de,
       apw@shadowen.org, randy.dunlap@oracle.com, linux-mm@kvack.org
Subject: Re: [BUG] regression from 2.6.24-rc8-mm1 and 2.6.24-mm1 kernel panic
 while bootup
References: <47A81BC9.5060600@linux.vnet.ibm.com> <20080205002544.264a9484.akpm@linux-foundation.org>
In-Reply-To: <20080205002544.264a9484.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 05 Feb 2008 13:48:17 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>
[snip]

> argh, I'd forgotten about that.  You bisected it down to a clearly-innocent
> patch and none of the mm developers appeared interested.
> 
> Oh well, it'll probably be in mainline tomorrow.  That should get it
> fixed.

We've tracked this down to a problem where the nodeid might be invalid. Kamalesh
is investigating problem. We suspect we are doing a kmalloc_node with an invalid
nodeid.

We see

cpu with no node 2, num_online_nodes 1
cpu with no node 3, num_online_nodes 1

in the bootlog. Kamalesh verified that the problem exists with both slub and slab.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
