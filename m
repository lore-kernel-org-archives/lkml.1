Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYEOJbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYEOJbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 05:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYEOJbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 05:31:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36553 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbYEOJbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 05:31:14 -0400
Message-ID: <482C02A4.80101@firstfloor.org>
Date: Thu, 15 May 2008 11:30:12 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, muli@il.ibm.com,
       alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
References: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>	<87y76cym96.fsf@basil.nowhere.org> <20080515181619R.tomof@acm.org>
In-Reply-To: <20080515181619R.tomof@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Thu, 15 May 2008 11:01:09 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
>> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
>>
>>> This patchset adds per-device dma_mapping_ops support for
>>> CONFIG_X86_64 like POWER architecture does. This change enables us to
>>> cleanly fix the Calgary IOMMU issue that some devices are not behind
>>> the IOMMU [1]. It also would be helpful to handle KVM PCI passthrough.
>> This makes it basically impossible to do stack ops, which some 
>> people have been doing.
> 
> Seems that I misunderstand what those people want.
> 
> What those people want to do and how the stack ops achieve it? Or can
> you tell me where their patches are?

I've seen it in two cases: first was for KVM IO bypass and the other was a 
(unfinished) patch to support the NoDMA bitmaps on some systems.

In this case you really want to do a wrapper around the existing ops
and extend the mapping. 

That worked fine by just replacing the global pointer, but will
be quite hard in your set up.

-Andi


