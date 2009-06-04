Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZFDJGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZFDJGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbZFDJGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:06:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:61560 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbZFDJGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vovQs2EH2rD/EJBB76xCPPR4RJswSFinWvOINiCD36kg0eeMTVFCn5NukXLIoVv04Y
         76BRlhmMYYCaxRD1MRiHsYFBYlJQitvrZ5flxefcrTUdsCvexilpmysGGvegFWcnSxnP
         SywZFxaOPWl75JGQ0MTr6b7wkwqD7MaWfjpGc=
Date: Thu, 4 Jun 2009 17:08:39 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ying.huang@intel.com, W.Li@Sun.COM,
       michaele@au1.ibm.com, mingo@elte.hu, heicars2@linux.vnet.ibm.com,
       mschwid2@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
Message-ID: <20090604090839.GB7030@cr0.nay.redhat.com>
References: <20090602114359.129247921@linux.vnet.ibm.com> <20090602114402.951631599@linux.vnet.ibm.com> <20090602150324.c706b1d2.akpm@linux-foundation.org> <4A266546.5080601@linux.vnet.ibm.com> <4A26961E.7040207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A26961E.7040207@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 05:26:22PM +0200, Peter Oberparleiter wrote:
>Peter Oberparleiter wrote:
>> Andrew Morton wrote:
>>> On Tue, 02 Jun 2009 13:44:02 +0200
>>> Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
>>>> +	/* Duplicate gcov_info. */
>>>> +	active = num_counter_active(info);
>>>> +	dup = kzalloc(sizeof(struct gcov_info) +
>>>> +		      sizeof(struct gcov_ctr_info) * active, GFP_KERNEL);
>>> 
>>> How large can this allocation be?
>> 
>> Hm, good question. Having a look at my test system, I see coverage data 
>> files of up to 60kb size. With counters making up the largest part of 
>> those, I'd guess the allocation size can be around ~55kb. I assume that 
>> makes it a candidate for vmalloc?
>
>A further run with debug output showed that the maximum size is
>actually around 4k, so in my opinion, there is no need to switch
>to vmalloc.

Unless you want virtually continious memory, you don't need to
bother vmalloc().

kmalloc() and get_free_pages() are all fine for this.
