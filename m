Return-Path: <linux-kernel-owner+w=401wt.eu-S1751787AbZL3BEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbZL3BEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZL3BEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:04:12 -0500
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:35999
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbZL3BEL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:04:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEBAN81Okt8qNTn/2dsb2JhbAAI1HaEMQSBZQ
X-IronPort-AV: E=Sophos;i="4.47,471,1257091200"; 
   d="scan'208";a="538820046"
Subject: Re: Question of resource_size() implementation
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <1262132171.28789.136.camel@gandalf>
Date: Wed, 30 Dec 2009 12:04:07 +1100
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <251FB18F-5D6A-4BBE-A69D-F6203E09058B@niasdigital.com>
References: <1262130234.28789.112.camel@gandalf> <1262131932.1888.202.camel@Joe-Laptop.home> <1262132171.28789.136.camel@gandalf>
To: me@felipebalbi.com
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 30/12/2009, at 11:16 AM, Felipe Balbi wrote:

> On Tue, 2009-12-29 at 16:12 -0800, Joe Perches wrote:
>> On Wed, 2009-12-30 at 01:43 +0200, Felipe Balbi wrote:
>>> I'm wondering whether the +1 in resource_size() is actually necessary.
>>> resource_size() is defined as:
>> []
>>> static inline resource_size_t resource_size(const struct resource *res)
>>> {
>>> 	return res->end - res->start + 1;
>>> }
>>> Are we off-by-one
>>> here ? Or is this all expected ?
>> 
>> Imagine you have 1 byte sized resources.
>> 
>> AREA1 = 0x40000000
>> AREA2 = 0x40000001
>> 
>> area1.start = 0x40000000
>> area1.end   = 0x40000000
>> 
>> area2.start = 0x40000001
>> area2.end   = 0x40000001
> 
> (adding lkml back to the loop)
> 
> in that you wouldn't use any of the SZ_* macros and simply hardcode
> start and end, right ? then you would define:
> 
> area1.start = 0x40000000
> area1.end = 0x40000001

No-o, you'd hardcode

area1.start=0x40000000
area1.end=0x40000000

As Joe wrote.  Then the resource_size would return 1 and ioremap would map the 1 byte starting at 0x400000000, i.e. just 0x400000000.  This is correct.

In your original example you had

		.start	= MEM_AREA1_BASE,
		.end	= MEM_AREA1_BASE + SZ_4K - 1

So resource_size would return SZ_4K and ioremap would map the SZ_4K bytes starting at MEM_AREA1_BASE, i.e. MEM_AREA1_BASE to MEM_AREA1_BASE - 1 /inclusive/.  This is also correct.

	--Ben.

