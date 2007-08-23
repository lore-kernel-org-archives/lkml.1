Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbXHWUN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbXHWUN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758648AbXHWUNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:13:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757719AbXHWUNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:13:17 -0400
Date: Thu, 23 Aug 2007 13:12:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
cc: Hirokazu Takata <takata@linux-m32r.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       Chris Snook <csnook@redhat.com>, Chris Friesen <cfriesen@nortel.com>
Subject: Re: [PATCH 11/23] make atomic_read() and atomic_set() behavior
 consistent on m32r
In-Reply-To: <e8b5ee6194ed619c245eb884c5ae6b11@kernel.crashing.org>
Message-ID: <alpine.LFD.0.999.0708231310430.30176@woody.linux-foundation.org>
References: <46C03885.7000109@redhat.com> <20070813112452.GK24018@shell.boston.redhat.com>
 <swfhcmswcux.wl%takata.hirokazu@renesas.com> <swfejhww4cs.wl%takata.hirokazu@renesas.com>
 <46CC42EF.3030602@redhat.com> <8fc86c23579e12b012891d6e69b1b107@kernel.crashing.org>
 <alpine.LFD.0.999.0708221116310.30176@woody.linux-foundation.org>
 <e8b5ee6194ed619c245eb884c5ae6b11@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Aug 2007, Segher Boessenkool wrote:
> 
> This simply isn't true.  The compiler *can* combine asm stuff:

Please Segher, just shut up.

The combining, which I've mentioned *multiple*times* is

	if (atomic_read(&x) <= 1)

and dammit, if that doesn't result in a *single* instruction, the code 
generation is pure and utter crap.

It should result in

	cmpl $1,offset(reg)

and nothing else. And there is no way in hell you are doing that with 
"atomic_read()" being inline asm.

So can you now just go away?

		Linus
