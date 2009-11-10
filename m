Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbZKJTAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbZKJTAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757765AbZKJTAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:00:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757754AbZKJTAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:00:03 -0500
Date: Tue, 10 Nov 2009 13:59:44 -0500
From: Dave Jones <davej@redhat.com>
To: x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: x86: add new cache descriptors
Message-ID: <20091110185944.GA20935@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20091110184924.GA20337@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110184924.GA20337@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 01:49:24PM -0500, Dave Jones wrote:
 
 > diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
 > index 804c40e..228fc67 100644
 > --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
 > +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
 > @@ -102,6 +102,9 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 >  	{ 0xe2, LVL_3,    2048 },	/* 16-way set assoc, 64 byte line size */
 >  	{ 0xe3, LVL_3,    4096 },	/* 16-way set assoc, 64 byte line size */
 >  	{ 0xe4, LVL_3,    8192 },	/* 16-way set assoc, 64 byte line size */
 > +	{ 0xea, LVL_3,    12288 },	/* 24-way set assoc, 64 byte line size */
 > +	{ 0xeb, LVL_3,    18432 },	/* 24-way set assoc, 64 byte line size */
 > +	{ 0xec, LVL_3,    24576 },	/* 24-way set assoc, 64 byte line size */
 >  	{ 0x00, 0, 0}

btw, something I'm thinking of doing as a followup is making these use the
defines like we have in drivers/char/agp/agp.h

#define KB(x)   ((x) * 1024)
#define MB(x)   (KB (KB (x)))
#define GB(x)   (MB (KB (x)))

There's a few similar definitions throughout the tree.  Any opinions on whether
I should add these to kernel.h, or create a new header for them ?

	Dave

