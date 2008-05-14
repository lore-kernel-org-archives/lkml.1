Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbYENTCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbYENTCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbYENTB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:01:58 -0400
Received: from waste.org ([66.93.16.53]:46407 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067AbYENTB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:01:57 -0400
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, Hugh Dickins <hugh@veritas.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1210288532.7905.89.camel@nimitz.home.sr71.net>
References: <1210106579.4747.51.camel@nimitz.home.sr71.net>
	 <20080508143453.GE12654@escobedo.amd.com>
	 <1210258350.7905.45.camel@nimitz.home.sr71.net>
	 <20080508151145.GG12654@escobedo.amd.com>
	 <1210261882.7905.49.camel@nimitz.home.sr71.net>
	 <20080508161925  <20080508200239.GJ12654@escobedo.amd.com>
	 <1210288532.7905.89.camel@nimitz.home.sr71.net>
Content-Type: text/plain
Date: Wed, 14 May 2008 14:01:41 -0500
Message-Id: <1210791701.4093.29.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 16:15 -0700, Dave Hansen wrote:
> Here's one quick stab at a solution.  I figured that we already pass
> that 'private' variable around.  This patch just sticks that variable
> *in* the mm_walk and also makes the caller fill in an 'mm' as well.
> Then, we just pass the actual mm_walk around.
> 
> Maybe we should just stick the VMA in the mm_walk as well, and have the
> common code keep it up to date with the addresses currently being
> walked.
> 
> Sadly, I didn't quite get enough time to flesh this idea out very far
> today, and I'll be offline for a couple of days now.  But, if someone
> wants to go this route, I thought this might be useful.  

This much looks reasonable. But the real test of course is to actually
teach it about detecting huge pages efficiently. And I suspect that
means tracking the current VMA all the time in the walk. Am I wrong?

-- 
Mathematics is the supreme nostalgia of our time.

