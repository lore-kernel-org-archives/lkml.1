Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbYFAKcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbYFAKcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 06:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYFAKbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 06:31:52 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58748 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbYFAKbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 06:31:52 -0400
Message-ID: <48427A13.7050704@cs.helsinki.fi>
Date: Sun, 01 Jun 2008 13:29:39 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       David Howells <dhowells@redhat.com>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
References: <483DBA85.2060502@cs.helsinki.fi> <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com> <483DBFC3.1070108@cs.helsinki.fi> <29611.1212066517@redhat.com> <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi> <20080529211207.GB13663@linux-sh.org> <484256AA.3000709@cs.helsinki.fi> <Pine.LNX.4.64.0806011119420.11749@sbz-30.cs.Helsinki.FI> <20080601082427.GC25429@linux-sh.org> <Pine.LNX.4.64.0806011208480.13090@sbz-30.cs.Helsinki.FI> <20080601102401.GD25429@linux-sh.org>
In-Reply-To: <20080601102401.GD25429@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 12:13:02PM +0300, Pekka J Enberg wrote:
>> I mean, assuming the BUG_ON bits are bogus, then we should always pass the 
>> pointer to the allocator. I audited most of the callers and they all seem 
>> to be really just using kmalloc() for allocation anyway.
>>
>> What do you think?

Paul Mundt wrote:
> Isn't this what my original patch did? ;-)

Oh, almost, you had this bit in ksize() of SLAB:

+	page = virt_to_head_page(objp);
+	if (unlikely(!PageSlab(page)))
+		return PAGE_SIZE << compound_order(page);

Did you actually need it for something?

		Pekka
