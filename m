Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYGaOFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYGaOFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYGaOFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:05:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642AbYGaOFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:05:38 -0400
Message-ID: <4891C66A.3040302@linux-foundation.org>
Date: Thu, 31 Jul 2008 09:04:26 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm <linux-mm@kvack.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC:Patch: 000/008](memory hotplug) rough idea of pgdat removing
References: <20080731203549.2A3F.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20080731203549.2A3F.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:

> Current my idea is using RCU feature for waiting them.
> Because it is the least impact against reader's performance,
> and pgdat remover can wait finish of reader's access to pgdat
> which is removing by synchronize_sched().

The use of RCU disables preemption which has implications as to what can be done in a loop over nodes or zones. This would also potentially add more overhead to the page allocator hotpaths.


> If you have better idea, please let me know.

Use stop_machine()? The removal of a zone or node is a pretty rare event after all and it would avoid having to deal with rcu etc etc.

