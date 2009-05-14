Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZENDo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZENDo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 23:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZENDoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 23:44:17 -0400
Received: from mga10.intel.com ([192.55.52.92]:50439 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754552AbZENDoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 23:44:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,192,1241420400"; 
   d="scan'208";a="457013148"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: Extend test_and_set_bit() test_and_clean_bit() to 64 bits in X86_64
Date: Thu, 14 May 2009 11:45:05 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "linux-mm" <linux-mm@kvack.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
References: <1242202647-32446-1-git-send-email-sheng@linux.intel.com> <87zldhl7ne.fsf@basil.nowhere.org>
In-Reply-To: <87zldhl7ne.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905141145.05591.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 May 2009 16:38:29 Andi Kleen wrote:
> Sheng Yang <sheng@linux.intel.com> writes:
> > -static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
> > +static inline int test_and_set_bit(long int nr, volatile unsigned long
> > *addr) {
> >  	int oldbit;
> >
> > -	asm volatile(LOCK_PREFIX "bts %2,%1\n\t"
> > +	asm volatile(LOCK_PREFIX REX_X86 "bts %2,%1\n\t"
>
> Use btsq on 64bit, then you don't need the explicit rex prefix.

Hi Andi

Well, I just think lots of "#ifdef/#else" is a little annoying here, then use 
REX...

-- 
regards
Yang, Sheng
