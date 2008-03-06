Return-Path: <linux-kernel-owner+w=401wt.eu-S935230AbYCFCgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935230AbYCFCgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935107AbYCFCfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:35:20 -0500
Received: from n9a.bullet.mail.mud.yahoo.com ([209.191.87.108]:31995 "HELO
	n9a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935103AbYCFCfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:35:18 -0500
X-Yahoo-Newman-Id: 249675.57036.bm@omp406.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uj2VuRW3ASsR0QFy047PS3SppIF630aNt0o3JopSMQwu3oTLMsJjeiVGWDaDqx8HrG/LBykqaCPHCF/LHGnwl8tfvinm6RKpragvhYOHqt2BzOmfNa3F05A1rH8SCn0jtsMR62GBQueZGUH1AFxFBz9irtVkB1vFPtFdW7SGgJA=  ;
X-YMail-OSG: wYzUOlEVM1kmpqwX4e_WvfhZtnJm8hsILsXBfQoNZCdY_dhXZ8z7g4GJOYdizKtY0lfafRJzLg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/5] vmalloc: do not check for freed locks on user maps
Date: Thu, 6 Mar 2008 13:34:58 +1100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
References: <20080305154829.185609547@linutronix.de> <200803060956.43671.nickpiggin@yahoo.com.au> <alpine.LFD.1.00.0803060029131.3099@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803060029131.3099@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803061334.58481.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008 10:31, Thomas Gleixner wrote:
> On Thu, 6 Mar 2008, Nick Piggin wrote:

> > This is the kernel mapping. The user mapping is unmapped when
> > the userspace munmaps.
>
> Ok, my misinterpretation of that flag. Is the user space unmap in the
> same code path ? If yes, how can it be distinguished from the kernel
> space unmap ?

The flag I added so that the vmap can be passed to remap_vmalloc_range.
There were a couple of places at one point that were not zeroing out
the vmalloced memory correctly, so this just helps ensure we don't leak
data.

Userspace unmap is unmap_vmas and related code in mm/memory.c.

