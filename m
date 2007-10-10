Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbXJJWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbXJJWDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 18:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbXJJWDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 18:03:09 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:25982 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754810AbXJJWDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 18:03:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZmNE/7RhVeKuSljXJLlUm0u6az/AIGMuTn3GWrznJFpKosF+Hn1bvkT2w26QlUbdgCw9BbxjmrIBL8yo5LDT184BmLb/pirinlCRsTgHJaNqxLXMa+JpbkwIYouCpIdaooZn27xjPy9uHigoICzjo6dWfjCA5+1QHSZsBrrLSW0=  ;
X-YMail-OSG: tYAeR_kVM1mqo7gJs_ILth517PdAxBQEPI9LRRa1klyl3CgI1QohnmqsIDQ1R6pGBN6JjpK6tQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Berkley Shands <berkley@cse.wustl.edu>
Subject: Re: 2.6.23 spinlock hang in kswapd under heavy disk write loads
Date: Wed, 10 Oct 2007 15:31:26 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20071010153332.71479CECBD@tamarack.cse.wustl.edu>
In-Reply-To: <20071010153332.71479CECBD@tamarack.cse.wustl.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710101531.26944.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2007 01:33, Berkley Shands wrote:
> 2.6.23 with CONFIG_DEBUG_SPINLOCK on does not hang under very high write
> loads to either an LSI8888ELP (write rate 1.1GB/Sec) or to a highpoint
> RR2340 (write rate 1.0GB/Sec). With CONFIG_DEBUG_SPINLOCK off however, the
> system hangs with kswapd getting 100% of the cpu and most if not all other
> processes are locked out. Sometimes even the keyboard is locked out.
>
> This is seen on a supermicro H8DM3-2 and H8DMi-2 motherboards, 16 GB RAM,
> 2222 SE or 2216 processors. Not seen on a Uniwide 3546ES, or on a
> Supermicro H8DM8 with 8222 CPUS.
>
> kswapd sits at (according to KDB)
> __spinlock_irqsave + 0x15
> prepare_to_wait + 0x15
> kswapd + 0xe3
> kthread + 0x47


This is the pgdat->kswapd_wait waitqueue lock, by the looks?
It should be basically impossible to get this lock wrong, so
perhaps what happens is some memory corruption which is padded
(or some other random change) by spinlock debugging?

Is this very reproducable? Does your dmesg have any funny
messages after performing this heavy write load with
CONFIG_DEBUG_SPINLOCK set?

