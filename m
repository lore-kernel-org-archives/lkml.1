Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbYBFJGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbYBFJGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 04:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759533AbYBFJGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 04:06:30 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:25952 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519AbYBFJG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 04:06:27 -0500
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080205104625.60fa86b0.akpm@linux-foundation.org>
References: <20071112143009.425807965@de.ibm.com>
	 <20071112144009.831296895@de.ibm.com>
	 <20080201151541.8e3e0359.akpm@linux-foundation.org>
	 <1202017020.7208.2.camel@pasglop>
	 <20080202215315.3ac6907d.akpm@linux-foundation.org>
	 <1202121409.31801.7.camel@localhost>
	 <20080204025133.511ac3e2.akpm@linux-foundation.org>
	 <1202222388.25021.20.camel@localhost>
	 <20080205104625.60fa86b0.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 06 Feb 2008 10:06:18 +0100
Message-Id: <1202288778.31295.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-05 at 10:46 -0800, Andrew Morton wrote:
> > I got x86-64 compiled by removing the #include <asm/pgalloc.h> from
> > asm-generic/tlb.h. But who knows what will break if the include is
> > missing .. I'll cross compile some of the other architectures next.
> > 
> 
> urgh, well, thanks for trying.  If there's significant risk factor (or
> hassle) in fixing the macros then I'd suggest we not do it for now - it's a
> separate project.

I'm still at it. I does make sense to convert the damn macros to inline
functions. The question now is the order of things, the macro cleanup
first or the sub-page page tables first? I would prefer the sub-page
page tables first since that code has been hanging around in -mm for a
while and could go upstream after I regenerated the patch and test
compiled it again. We do need it for KVM and we want to push our KVM
patches for s390 soon.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


